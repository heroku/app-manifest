require 'test_helper'

module AppManifest
  class EnvTest < MiniTest::Test
    def test_attributes
      size = "performance-m"
      quantity = 2

      formation = Formation.new(size: size, quantity: quantity)

      assert_equal(formation.quantity, quantity)
      assert_equal(formation.size, size)
    end
  end
end
