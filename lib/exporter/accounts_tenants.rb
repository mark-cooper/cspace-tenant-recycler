module Exporter

  class AccountsTenants < Table
    def apply_config
      {
        table: :accounts_tenants,
        hjid: true,
        query: { tenant_id: filter },
        attributes: [
          :tenant_id,
          :tenants_accounts_common_csid,
        ]
      }
    end

    def members(attribute: :tenants_accounts_common_csid)
      get_members(attribute: attribute)
    end
  end

end
