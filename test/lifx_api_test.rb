require "test_helper"

class LifxApiTest < Minitest::Test
	def test_that_it_has_a_version_number
		refute_nil ::LifxApi::VERSION
	end
end
