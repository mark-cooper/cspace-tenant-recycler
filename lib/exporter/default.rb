module Exporter

  class Default
    attr_reader :domain

    def initialize(domain:)
      @domain = domain
    end

    def apply_config
      {}
    end

    def members
      [domain]
    end
  end

end
