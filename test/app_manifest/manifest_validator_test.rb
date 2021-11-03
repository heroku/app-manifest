require 'test_helper'
require 'support/environment_tests'

module AppManifest
  class ManifestValidatorTest < MiniTest::Test

    def valid_manifest_hash
      {
        "name" => "Small Sharp Tool",
        "description" => "This app does one little thing, and does it well.",
        "keywords" => ["productivity", "HTML5", "scalpel"],
        "website" => "https://small-sharp-tool.com/",
        "repository" => "https://github.com/jane-doe/small-sharp-tool",
        "logo" => "https://small-sharp-tool.com/logo.svg",
        "success_url" => "/welcome",
        "scripts" => {
          "postdeploy" => "bundle exec rake bootstrap"
        },
        "env" => {
          "SECRET_TOKEN" => {
            "description" => "A secret key for verifying the integrity of signed cookies.",
            "generator" => "secret"
          },
          "WEB_CONCURRENCY" => {
            "description" => "The number of processes to run.",
            "value" => "5"
          }
        },
        "formation" => {
          "web" => {
            "quantity" => 1,
            "size" => "standard-1x"
          }
        },
        "image" => "heroku/ruby",
        "addons" => [
          "openredis",
          {
            "plan" => "mongolab:shared-single-small",
            "as" => "MONGO"
          },
          {
            "plan" => "heroku-postgresql",
            "options" => {
              "version" => "9.5"
            }
          }
        ],
        "buildpacks" => [
          {
            "url" => "https://github.com/stomita/heroku-buildpack-phantomjs"
          }
        ],
        "environments" => {
          "test" => {
            "scripts" => {
              "test" => "bundle exec rake test"
            }
          },
          "review" => {
            "addons" => [
              "openredis",
              {
                "plan" => "mongolab:shared-single-small",
                "as" => "MONGO"
              },
              {
                "plan" => "heroku-postgresql",
                "options" => {
                  "version" => "9.5"
                }
              }
            ]
          },
        }
      }
    end

    def test_validate_manifest__valid
      hash = valid_manifest_hash
      assert_silent do
        ManifestValidator.validate!(hash)
      end
    end

    def test_validate_environment_manifest__valid
      hash = {
        "environments" => {
          "test" => valid_manifest_hash,
          "review" => valid_manifest_hash
        }
      }
      assert_silent do
        ManifestValidator.validate!(hash)
      end
    end

    def test_validate_environment_name__invalid
      hash = {
        "environments" => {
          "buildpack" => {}
        }
      }
      error = assert_raises(AppManifest::InvalidManifest) do
        ManifestValidator.validate!(hash)
      end
      assert_match(/Invalid environment name: buildpack/i, error.message)
    end

    def test_validate_environment_value__invalid_type
      hash = {
        "environments" => {
          "test" => "foobar"
        }
      }
      error = assert_raises(AppManifest::InvalidManifest) do
        ManifestValidator.validate!(hash)
      end
      assert_match(/Expected object but got: String/i, error.message)
    end

    def test_validate_addons_value__invalid_type
      hash = {
        "addons" => {
          "test" => "foobar"
        }
      }
      error = assert_raises(AppManifest::InvalidManifest) do
        ManifestValidator.validate!(hash)
      end
      assert_match(/Expected array for key: addons but got: Hash/i, error.message)
    end
  end
end