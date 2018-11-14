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
          :metadata_protection,
          :perms_protection,
        ],
      }
    end

    def members
      data.map { |d| d[4] }
    end
  end

end
