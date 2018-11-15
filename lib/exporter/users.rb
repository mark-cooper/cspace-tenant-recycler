module Exporter

  class Users < Table
    def apply_config
      {
        table: :users,
        hjid: false,
        query: { username: filter },
        attributes: [
          :username,
          :created_at,
          :passwd
        ],
      }
    end

    def members(attribute: :username)
      get_members(attribute: attribute)
    end
  end

end
