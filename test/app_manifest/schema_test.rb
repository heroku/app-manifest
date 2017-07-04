require 'test_helper'

class AppManifest::SchemaTest < MiniTest::Test
  def test_extra_property
    hash = { namee: "foo" }
    schema = AppManifest::Schema.new(hash)

    assert schema.valid?
    assert_empty schema.errors
  end

  def test_valid_name
    hash = { name: "foo" }
    schema = AppManifest::Schema.new(hash)

    assert schema.valid?
    assert_empty schema.errors
  end

  def test_invalid_name
    hash = { name: 123 }
    schema = AppManifest::Schema.new(hash)

    refute schema.valid?

    error = schema.errors.first
    assert_equal "#/name", error.pointer
  end

  def test_valid_string_addons
    hash = { addons: ["foo", "bar:free"] }
    schema = AppManifest::Schema.new(hash)

    assert schema.valid?
    assert_empty schema.errors
  end

  def test_invalid_addons
    hash = { addons: 123 }
    schema = AppManifest::Schema.new(hash)

    refute schema.valid?

    error = schema.errors.first
    assert_equal "#/addons", error.pointer
  end

  def test_invalid_string_addons
    hash = { addons: [ 123 ] }
    schema = AppManifest::Schema.new(hash)

    refute schema.valid?

    error = schema.errors.first
    assert_equal "#/addons/0", error.pointer
  end

  def test_valid_object_addons
    hash = {
      addons: [{
        plan: "heroku-postgresql",
        as: "POSTGRES_URL",
        options: {
          version: "10.0"
        }
      }]
    }
    schema = AppManifest::Schema.new(hash)

    assert schema.valid?
    assert_empty schema.errors
  end

  def test_invalid_object_addons
    hash = {
      addons: [{
        perlan: "heroku-postgresql",
      }]
    }
    schema = AppManifest::Schema.new(hash)

    refute schema.valid?

    error = schema.errors.first
    assert_equal "#/addons/0", error.pointer
  end

  def test_valid_buildpacks
    hash = {
      buildpacks: [{
        url: "https://github.com/heroku/heroku-buildpack-nodejs"
      }]
    }
    schema = AppManifest::Schema.new(hash)

    assert schema.valid?
    assert_empty schema.errors
  end

  def test_invalid_buildpacks
    hash = {
      buildpacks: [{
        urls: "https://github.com/heroku/heroku-buildpack-nodejs"
      }]
    }
    schema = AppManifest::Schema.new(hash)

    refute schema.valid?

    error = schema.errors.first
    assert_equal "#/buildpacks/0", error.pointer
  end
end
