require "json-schema"

module AppManifest
  class Schema
    def self.validate(hash)
      JSON::Validator.fully_validate("schema/schema.json", hash)
    end
  end
end
