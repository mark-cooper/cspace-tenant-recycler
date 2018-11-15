module Exporter

  class Tenants < Table
    def apply_config
      {
        table: :tenants,
        hjid: false,
        query: { name: filter },
        attributes: [
          :id,
          :created_at,
          :name,
          # :config_md5hash,
          # :authorities_initialized,
          :disabled,
        ]
      }
    end

    def members(attribute: :id)
      get_members(attribute: attribute)
    end
  end

end
