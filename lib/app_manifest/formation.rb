module AppManifest
  class Formation
    include Virtus.model
    include Serializer

    attribute :quantity, Integer
    attribute :size,     String
  end
end
