require 'test_helper'

module AppManifest
  class BuildpackTest < MiniTest::Test
    def test_attributes
      url = 'https://github.com/heroku/heroku-buildpack-ruby'
      buildpack = Buildpack.new(url: url)


      assert_equal(buildpack.url, url)
    end
  end
end
