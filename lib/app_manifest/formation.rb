module AppManifest
  class Formation
    include Virtus.model

    attribute :quantity, Integer
    attribute :size,     String
  end
end
