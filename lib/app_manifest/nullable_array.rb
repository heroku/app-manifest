module AppManifest
  class NullableArray < Array; end

  class NullableArrayAttribute < Virtus::Attribute::Collection
    default nil
    required false
    primitive Array

    def coerce(value)
      value.nil? ? value : super(value)
    end
  end
end
