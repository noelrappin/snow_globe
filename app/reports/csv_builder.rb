class CsvBuilder

  attr_reader :columns, :options, :klass

  COLUMN_TRANSITIVE_OPTIONS = [:humanize_name].freeze

  def initialize(klass, options = {}, &block)
    @klass = klass
    @columns = []
    @options = options
    @block = block
  end

  def csv_options
    @csv_options ||= options.except(
        :encoding_options, :byte_order_mark, :column_names)
  end

  def column(name, options = {}, &block)
    @columns << Column.new(
        name, column_transitive_options.merge(options), block)
  end

  def collection
    @collection ||= klass.find_collection
  end

  def build(output, collection: nil)
    @collection = collection
    exec_columns
    add_byte_order_mark(output)
    build_header(output)
    build_rows(output)
    output
  end

  def add_byte_order_mark(output)
    bom = options.fetch(:byte_order_mark, false)
    output << bom if bom
  end

  def build_header(output)
    reuturn unless options.fetch(:column_names, true)
    headers = columns.map { |column| encode(column.name, options) }
    output << CSV.generate_line(headers, csv_options)
  end

  def build_rows(output)
    collection.each do |resource|
      row = build_row(resource, columns, options)
      output << CSV.generate_line(row, csv_options)
    end
  end

  def exec_columns
    @columns = []
    instance_exec(&@block) if @block.present?
    columns
  end

  def build_row(resource, columns, options)
    columns.map { |column| encode(column.value(resource), options) }
  end

  def encode(content, options)
    if options[:encoding]
      content.to_s.encode(options[:encoding], options[:encoding_options])
    else
      content
    end
  end

  private def column_transitive_options
    @column_transitive_options ||= @options.slice(*COLUMN_TRANSITIVE_OPTIONS)
  end

  private def batch_size
    1000
  end

  class Column

    attr_reader :name, :data, :options

    DEFAULT_OPTIONS = {humanize_name: true}.freeze

    def initialize(name, options = {}, block = nil)
      @options = options.reverse_merge(DEFAULT_OPTIONS)
      @name = humanize_name(name, @options[:humanize_name])
      @data = block || name.to_sym
    end

    def humanize_name(name, humanize_name_option)
      if humanize_name_option
        name.to_s.humanize
      else
        name.to_s
      end
    end

    def value(resource)
      case data
      when Symbol, String then resource.send(data)
      when Proc then resource.instance_exec(&data)
      end
    end

  end

end
