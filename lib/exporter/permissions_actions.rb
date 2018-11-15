module Exporter

  class PermissionsActions < Table
    attr_reader :id
    def initialize(id: nil)
      @id     = id
      @config = apply_config
      @data   = []
    end

    def apply_config
      {
        table: :permissions_actions,
        hjid: true,
        query: Sequel.like(:objectidentityresource, "#{id}:%"),
        attributes: [
          :name,
          :objectidentity,
          :objectidentityresource,
          :action__permission_csid,
        ],
      }
    end

    def members(attribute: :objectidentity)
      get_members(attribute: attribute)
    end
  end

end
