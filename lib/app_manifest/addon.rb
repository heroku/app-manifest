module AppManifest
  class Addon
    include Virtus.model
    include Serializer

    attribute :plan,    String
    attribute :as,      String
    attribute :options, Hash[String => String], default: nil
  end
end
