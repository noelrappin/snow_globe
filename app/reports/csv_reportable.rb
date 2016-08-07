module CsvReportable

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    attr_accessor :csv_builder

    def csv(options = {}, &block)
      self.csv_builder = CsvBuilder.new(self, options, &block)
    end

    def to_csv(collection: nil)
      csv_builder.build("", collection: collection)
    end

    def to_csv_enumerator(collection: nil)
      Enumerator.new do |y|
        csv_builder.build(y, collection: collection)
      end
    end

  end

end
