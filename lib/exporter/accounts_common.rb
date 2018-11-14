module Exporter

  class AccountsCommon < Table
    def config
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
          :metadata_protection,
          :roles_protection,
        ]
      }
    end

    def members
      data.map { |d| d[-3] }
    end
  end

end
