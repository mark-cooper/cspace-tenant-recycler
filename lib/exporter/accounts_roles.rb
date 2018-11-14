module Exporter

  class AccountsRoles < Table
    def apply_config
      {
        table: :accounts_roles,
        hjid: true,
        query: { role_name: filter },
        attributes: [
          :account_id,
          :created_at,
          :role_id,
          :role_name,
          :user_id,
        ],
      }
    end

    def members
      []
    end
  end

end
