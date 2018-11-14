module Exporter

  class Default
    attr_reader :domain

    def initialize(domain:)
      @domain = domain
    end

    def config
      {}
    end

    def members
      [domain]
    end
  end

end
