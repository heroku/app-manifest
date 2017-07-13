module AppManifest
  class Env
    include Virtus.model
    include Hasherator

    attribute :description, String
    attribute :generator,   String
    attribute :required,    Boolean
    attribute :value,       String
  end
end
