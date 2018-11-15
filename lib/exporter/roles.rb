module Exporter

  class Roles < Table
    def apply_config
      {
        table: :roles,
        hjid: false,
        query: { tenant_id: filter },
        attributes: [
          :csid,
          :created_at,
          :description,
          :displayname,
          :rolename,
          :tenant_id,
          # :metadata_protection,
          :perms_protection,
        ],
      }
    end

    def members(attribute: :rolename)
      get_members(attribute: attribute)
    end
  end

end
