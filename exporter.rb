#!/usr/bin/env ruby
# ./exporter.rb

require_relative 'requirements'

LOGGER     = Logger.new('log/exporter.log')
OUTPUT_DIR = FileUtils.mkdir_p('exporter')

config = YAML.load_file('config.yml')
config['exporter']['db']['adapter'] = :postgres
config['exporter']['db']['logger']  = LOGGER

TENANT_ID     = config['exporter']['tenant']['id']
TENANT_DOMAIN = config['exporter']['tenant']['domain']

puts "Exporting data for tenant #{TENANT_ID}:#{TENANT_DOMAIN}"

DB = Sequel.connect(config['exporter']['db'])

EXPORTERS = {
  default: {
    class: Exporter::Default.new(domain: TENANT_DOMAIN),
  },
  tenants: {
    class: Exporter::Tenants.new,
    members: :default,
  },
  accounts_tenants: {
    class: Exporter::AccountsTenants.new,
    members: :tenants,
  },
  accounts_common: {
    class: Exporter::AccountsCommon.new,
    members: :accounts_tenants,
  },
  users: {
    class: Exporter::Users.new,
    members: :accounts_common,
  },
  roles: {
    class: Exporter::Roles.new,
    members: :tenants,
  },
  accounts_roles: {
    class: Exporter::AccountsRoles.new,
    members: :roles,
  },
  permissions: {
    class: Exporter::Permissions.new,
    members: :tenants,
  },
  permissions_roles: {
    class: Exporter::PermissionsRoles.new,
    members: :roles,
  },
  permissions_actions: {
    class: Exporter::PermissionsActions.new(id: TENANT_ID),
  },
}

EXPORTERS.each do |name, exporter|
  next if name == :default
  if exporter.key? :members
    members = EXPORTERS[exporter[:members]][:class].members
    exporter[:class].add_filter(members)
  end
  exporter[:class].query
  exporter[:class].export(output_dir: OUTPUT_DIR)
end

# ACL
objectidentities = EXPORTERS[:permissions_actions][:class].members
roles            = EXPORTERS[:roles][:class].members

data = DB[%Q(
  SELECT
    aclo.object_id_class,
    aclo.object_id_identity,
    aclo.owner_sid,
    aclo.entries_inheriting,
    acls.principal,
    acls.sid,
    acle.ace_order,
    acle.mask,
    acle.granting,
    acle.audit_success,
    acle.audit_failure
  FROM acl_entry acle
  JOIN acl_sid acls ON acle.sid = acls.id
  JOIN acl_object_identity aclo ON acle.acl_object_identity = aclo.id
  WHERE acls.sid IN (#{roles.map{ |v| "'#{v}'" }.join(',')})
  AND aclo.object_id_identity IN (#{objectidentities.map{ |v| "'#{v}'" }.join(',')})
)]

CSV.open(
    File.join(OUTPUT_DIR, "acl.csv"),
    'w',
    write_headers: true,
    headers: [
      :object_id_class,
      :object_id_identity,
      :owner_sid,
      :entries_inheriting,
      :principal,
      :sid,
      :ace_order,
      :mask,
      :granting,
      :audit_success,
      :audit_failure
    ]
  ) do |hdr|
  data.each { |d| hdr << d }
end
puts "Exported #{data.count} record/s from acl"
