require "json_schema"
require "multi_json"

module AppManifest
  class Schema
    attr_reader :errors

    def initialize(hash)
      @hash = hash
    end

    def validate
      @valid, @errors = self.class.schema.validate(hash)
    end

    # TODO: memoize
    def valid?
      validate
      @valid
    end

    private

    def hash
      @_hash ||= MultiJson.decode(MultiJson.encode(@hash))
    end

    def schema
      self.class.schema
    end

    def self.schema
      @schema ||= begin
        json = MultiJson.decode(File.read(File.join("schema", "schema.json")))
        schema = JsonSchema.parse!(json)
        schema.expand_references!
        schema
      end
    end
  end
end
