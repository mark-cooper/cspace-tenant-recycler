module Exporter

  class Tenants < Table
    def config
      {
        table: :tenants,
        hjid: false,
        query: { name: filter },
        attributes: [
          :id,
          :created_at,
          :name,
          :config_md5hash,
          :authorities_initialized,
          :disabled,
        ]
      }
    end

    def members
      data.map { |d| d[0] }
    end
  end

end
