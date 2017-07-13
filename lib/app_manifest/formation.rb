module AppManifest
  class Formation
    include Virtus.model
    include Hasherator

    attribute :quantity, Integer
    attribute :size,     String
  end
end
