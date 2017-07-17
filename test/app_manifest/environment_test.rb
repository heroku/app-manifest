require 'test_helper'
require 'support/environment_tests'

module AppManifest
  class EnvironmentTest < MiniTest::Test
    include EnvironmentTests
    def environment_class
      Environment
    end
  end
end
