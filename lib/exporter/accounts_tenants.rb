module Exporter

  class AccountsTenants < Table
    def config
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

    def members
      data.map { |d| d[-1] }
    end
  end

end
