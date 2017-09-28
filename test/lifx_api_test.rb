require "test_helper"

class LifxApiTest < Minitest::Test
	def test_that_it_has_a_version_number
		refute_nil ::LifxApi::VERSION
	end

	def test_selector_validation
		lifx = LifxApi.new 'access_token'

		{
			'all' => true,
			'all:random' => true,
			'all|3,all:random' => true,
			'all|1-4' => true,
			'all|1|2|3|4' => true,
			'group:Lounge' => true,
			'group:Lounge:random' => true,
			'group_id:1c8de82b81f445e7cfaafae49b259c71' => true,
			'id:d3b2f2d97452' => true,
			'label:Bedroom,label:Office' => true,
			'label:Left Lamp' => true,
			'location:Home' => true,
			'location:Kitchen|1|5|9' => true,
			'location_id:1d6fe8ef0fde4c6d77b0012dc736662c' => true,
			'location_id:1d6fe8ef0fde4c6d77b0012dc736662c:random' => true,
			'scene_id:1d6fe8ef0fde4c6d77b0012dc736662c' => true,
			'banana' => false,
			'all,banana' => false,
			'all:random|3' => false,
		}.each do |selector, expected_result|

			assert_equal expected_result, lifx.send(:valid?, selector, :selector), "#{selector} failed :selector validation"

		end
	end

	def test_numeric_validation
		lifx = LifxApi.new 'access_token'

		{
			'1234' => true,
			1234 => true,
			'one' => false
		}.each do |selector, expected_result|
			assert_equal expected_result, lifx.send(:valid?, selector, :numeric), "#{selector} failed :numeric validation"
		end
		# value.is_a?(Numeric) or value =~ /^[\d\.]+$/
	end

	def test_boolean_validation
		lifx = LifxApi.new 'access_token'

		{
			true => true,
			false => true,
			'true' => true,
			'false' => true,
			'maybe' => false,
			:nil => false,
		}.each do |selector, expected_result|
			assert_equal expected_result, lifx.send(:valid?, selector, :boolean), "#{selector} failed :boolean validation"
		end
		# ['true', 'false', true, false].include? value
	end

	def test_on_off_validation
		lifx = LifxApi.new 'access_token'

		{
			'on' => true,
			'off' => true,
			'Schrödinger' => false,
			nil => false,

		}.each do |selector, expected_result|
			assert_equal expected_result, lifx.send(:valid?, selector, :on_off), "#{selector} failed :on_off validation"
		end
		# ['on', 'off'].include? value
	end

	def test_hash_validation
		lifx = LifxApi.new 'access_token'

		{
			{} => true,
			[] => false,
			nil => false,
		}.each do |selector, expected_result|
			assert_equal expected_result, lifx.send(:valid?, selector, :hash), "#{selector} failed :hash validation"
		end
		# value.is_a? Hash
	end

	def test_string_validation
		lifx = LifxApi.new 'access_token'

		{
			"Hello, World!" => true,
			nil => false,
		}.each do |selector, expected_result|
			assert_equal expected_result, lifx.send(:valid?, selector, :string), "#{selector} failed :string validation"
		end
		# value.is_a? String
	end

	def test_uuid_validation
		lifx = LifxApi.new 'access_token'

		{
			'b854305d-81c9-4e56-b697-e47199ab9c7c' => true,
			'bananas' => false,
			nil => false,
		}.each do |selector, expected_result|
			assert_equal expected_result, lifx.send(:valid?, selector, :uuid), "#{selector} failed :uuid validation"
		end
		# val
	end

	def test_ignore_array
		lifx = LifxApi.new 'access_token'

		{
			[] => true,
			['power'] => true,
			['brightness', 'duration', 'hue', 'infrared', 'intensity', 'kelvin', 'power', 'saturation'] => true,
			[''] => false,
			'power' => false,
			'brightness' => false,
			nil => false,
		}.each do |selector, expected_result|
			assert_equal expected_result, lifx.send(:valid?, selector, :ignore_array), "#{selector} failed :ignore_array validation"
		end
	end

	def test_direction_validation
		lifx = LifxApi.new 'access_token'

		{
			'forward' => true,
			'backward' => true,
			'brightness' => false,
			nil => false,
		}.each do |selector, expected_result|
			assert_equal expected_result, lifx.send(:valid?, selector, :direction), "#{selector} failed :direction validation"
		end
	end

	def test_state_validation
		lifx = LifxApi.new 'access_token'

		{
			{
				power: 'on',
				color: 'red',
				brightness: '1.0',
				duration: '1234',
				infrared: '1.0',
			} => true,
			{
				power: 'off',
				color: '#ff0000',
			} => true,
			{
				power: '50%',
			} => false,
			'brightness' => false,
			nil => false,
		}.each do |selector, expected_result|
			assert_equal expected_result, lifx.send(:valid?, selector, :state), "#{selector} failed :state validation"
		end
	end

	def test_array_of_states_validation
		lifx = LifxApi.new 'access_token'

		{
			[{
				selector: 'all',
				power: 'on',
				color: 'red',
				brightness: '1.0',
				duration: '1234',
				infrared: '1.0',
			}] => true,
			[{
				selector: 'label:Kitchen',
				power: 'on',
			}, {
				selector: 'label:Playroom',
				infrared: 'off',
			}] => false,
			nil => false,
		}.each do |selector, expected_result|
			assert_equal expected_result, lifx.send(:valid?, selector, :array_of_states), "#{selector} failed :array_of_states validation"
		end
	end


	def test_validators_exist_for_all_data_types
		lifx = LifxApi.new 'access_token'

		LifxApi::ENDPOINTS.flat_map do |endpoint|
			endpoint.select { |k, _| /_params$/ === k.to_s }.values
		end.flat_map(&:values).map { |v| v[:type] }.sort.uniq.each do |value_format|

			# a missing test will raise an exception
			assert [true, false].include? lifx.send(:valid?, "", value_format)

		end

	end

end
