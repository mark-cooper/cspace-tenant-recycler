module Exporter

  class Permissions < Table
    def apply_config
      {
        table: :permissions,
        hjid: false,
        query: { tenant_id: filter },
        attributes: [
          :csid,
          :action_group,
          :created_at,
          :description,
          :effect,
          # :metadata_protection,
          # :actions_protection,
          :resource_name,
          :tenant_id,
        ],
      }
    end

    def members(attribute: :csid)
      get_members(attribute: attribute)
    end
  end

end
