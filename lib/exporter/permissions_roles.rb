module Exporter

  class PermissionsRoles < Table
    def apply_config
      {
        table: :permissions_roles,
        hjid: true,
        query: { role_name: filter },
        attributes: [
          :actiongroup,
          :created_at,
          :permission_id,
          :permission_resource,
          :role_id,
          :role_name,
        ],
      }
    end

    def members
      []
    end
  end

end
