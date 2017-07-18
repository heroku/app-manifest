require 'test_helper'

module AppManifest
  class EnvTest < MiniTest::Test
    def test_attributes
      description = 'A skeleton key'
      generator = 'secret'
      value = 'abc123'

      env = Env.new(
        description: description,
        generator: generator,
        value: value
      )

      assert_equal(env.description, description)
      assert_equal(env.generator, generator)
      assert_equal(env.value, value)
    end
  end
end
