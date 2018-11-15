module Exporter

  class AccountsCommon < Table
    def apply_config
      {
        table: :accounts_common,
        hjid: false,
        query: { csid: filter },
        attributes: [
          :csid,
          :created_at,
          :email,
          :screen_name,
          :status,
          :userid,
          # :metadata_protection,
          :roles_protection,
        ]
      }
    end

    def members(attribute: :userid)
      get_members(attribute: attribute)
    end
  end

end
