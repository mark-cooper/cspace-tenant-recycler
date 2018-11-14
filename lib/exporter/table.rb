module Exporter

  module Queryable
    def add_filters(args = [])
      @filter = args
      @config = config
    end

    def query
      @data = DB[config[:table]].where(config[:query]).select_map(config[:attributes])
      self
    end
  end

  module Exportable
    def export(output_dir:)
      CSV.open(
          File.join(output_dir, "#{config[:table]}.csv"),
          'w',
          write_headers: true,
          headers: config[:attributes]
        ) do |hdr|
        data.each { |d| hdr << d }
      end
      puts "Exported #{data.count} record/s from #{config[:table]}"
    end
  end

  class Table
    include Exportable
    include Queryable
    attr_reader :config, :data, :filter

    def initialize(filter: [])
      @config = config
      @data   = []
      @filter = filter
    end

    def config
      {}
    end

    def members
      []
    end
  end

end
