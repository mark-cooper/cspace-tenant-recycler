#!/usr/bin/env ruby
# ./exporter.rb

require 'csv'
require 'fileutils'
require 'logger'
require 'pg'
require 'pp'
require 'sequel'
require 'yaml'

require_relative 'lib/exporter/table'
require_relative 'lib/exporter/default'
require_relative 'lib/exporter/tenants'
require_relative 'lib/exporter/accounts_tenants'
require_relative 'lib/exporter/accounts_common'
require_relative 'lib/exporter/users'

LOGGER     = Logger.new('log/exporter.log')
OUTPUT_DIR = FileUtils.mkdir_p('exporter')

config = YAML.load_file('config.yml')
config['db']['adapter'] = :postgres
config['db']['logger']  = LOGGER

TENANT_ID     = config['tenant']['id']
TENANT_DOMAIN = config['tenant']['domain']

puts "Exporting data for tenant #{TENANT_ID}:#{TENANT_DOMAIN}"

DB = Sequel.connect(config['db'])

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
}

EXPORTERS.each do |name, exporter|
  next if name == :default
  members = EXPORTERS[exporter[:members]][:class].members
  exporter[:class].add_filters(members)
  exporter[:class].query
  exporter[:class].export(output_dir: OUTPUT_DIR)
end
