module AppManifest
  class Environment
    include Virtus.model
    include Serializer

    attribute :addons,      NullableArray[Addon]
    attribute :buildpacks,  NullableArray[Buildpack]
    attribute :description, String
    attribute :env,         Hash[String => Env],       default: nil
    attribute :formation,   Hash[String => Formation], default: nil
    attribute :image,       String
    attribute :keywords,    NullableArray[String]
    attribute :logo,        String
    attribute :name,        String
    attribute :repository,  String
    attribute :scripts,     Hash[String => String],    default: nil
    attribute :stack,       String
    attribute :success_url, String
    attribute :website,     String
  end
end
