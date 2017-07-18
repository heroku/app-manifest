module AppManifest
  # Setup attributes that are shared on Manifest and Environment models
  module EnvironmentAttributes
    def self.included(base)
      base.attribute :addons,      NullableArray[Addon]
      base.attribute :buildpacks,  NullableArray[Buildpack]
      base.attribute :description, String
      base.attribute :env,         Hash[String => Env],       default: nil
      base.attribute :formation,   Hash[String => Formation], default: nil
      base.attribute :image,       String
      base.attribute :keywords,    NullableArray[String]
      base.attribute :logo,        String
      base.attribute :name,        String
      base.attribute :repository,  String
      base.attribute :scripts,     Hash[String => String],    default: nil
      base.attribute :stack,       String
      base.attribute :success_url, String
      base.attribute :website,     String
    end
  end
end
