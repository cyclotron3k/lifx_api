require 'net/http'
require 'openssl'
require 'cgi'
require 'json'
require 'lifx_api/version'
require 'lifx_api/endpoints'
require 'lifx_api/error'

class LifxApi

	PROTOCOL = 'https'
	HOST     = 'api.lifx.com'
	DEBUG    = false

	def initialize(access_token)
		@access_token = access_token
		@base_uri = URI "#{PROTOCOL}://#{HOST}"

		@agent = Net::HTTP.new @base_uri.host, @base_uri.port
		@agent.use_ssl = PROTOCOL == 'https',
		@agent.keep_alive_timeout = 10
		@agent.set_debug_output $stdout if DEBUG
	end

	ENDPOINTS.each do |endpoint_spec|
		define_method endpoint_spec[:method_name], Proc.new { |params={}|
			parsed_params = parse_params endpoint_spec, params
			request = create_request endpoint_spec, parsed_params
			process_request request
		}
	end

	private

	def parse_params(endpoint_spec, params)
		[:path_params, :body_params, :query_params].each_with_object({}) do |field, parsed|
			next unless endpoint_spec[field]

			parsed[field] = endpoint_spec[field].each_with_object({}) do |(key, field_spec), clean|
				value = params[key] || field_spec[:default]
				raise "Missing #{key}" if field_spec[:required] and value.nil?
				next if value.nil?
				raise ArgumentError, "#{key} (#{value}) failed validation" unless valid? value, field_spec[:type]
				clean[key] = value
			end
		end
	end

	def valid?(value, value_format)
		case value_format
		when :selector
			value.split(',').all? do |selector|
				/^((label|id|(location|group)(_id)?|scene_id):.*|all)(:random|(\|[-\d]+)+)?$/ === selector
			end
		when :numeric, :brightness, :duration, :infrared
			value.is_a?(Numeric) or /^[\d\.]+$/ === value
		when :boolean
			['true', 'false', true, false].include? value
		when :on_off, :power
			['on', 'off'].include? value
		when :hash
			value.is_a? Hash
		when :string, :color
			value.is_a? String
		when :uuid
			value.is_a?(String) and /^[\da-f]{4}([\da-f]{4}-){4}[\da-f]{12}$/ === value
		when :ignore_array
			value.is_a?(Array) and (value - ['power', 'infrared', 'duration', 'intensity', 'hue', 'saturation', 'brightness', 'kelvin']).empty?
		when :direction
			value.is_a?(String) and ['forward', 'backward'].include? value
		when :array_of_states
			value.is_a?(Array) and value.count <= 50 and value.all? { |state| valid? state, :state }
		when :state
			value.is_a?(Hash) and (value.keys - [:selector, :power, :color, :brightness, :duration, :infrared]).empty? and value.all? { |k, v| valid? v, k }
		else
			raise ArgumentError, "Don't know how to validate #{value_format}"
			true
		end
	end

	def create_request(endpoint_spec, params)
		uri = @base_uri.clone

		uri.path = if params.key? :path_params
			endpoint_spec[:path] % Hash[params[:path_params].map { |k, v| [k, CGI.escape(v).gsub('+', '%20')]}]
		else
			endpoint_spec[:path]
		end

		if params.key? :query_params
			uri.query = URI.encode_www_form params[:query_params]
		end

		request = case endpoint_spec[:http_method]
		when :get
			Net::HTTP::Get.new uri
		when :put
			Net::HTTP::Put.new uri
		when :post
			Net::HTTP::Post.new uri
		else
			raise NotImplementedError, "Invalid HTTP method: #{endpoint_spec[:http_method]}"
		end

		if params.key? :body_params
			request.set_form_data params[:body_params]
		end

		request
	end

	def process_request(request)
		request['Authorization'] = "Bearer #{@access_token}"

		puts "\n\n\e[1;32mDespatching request to #{request.path}\e[0m" if DEBUG

		@session = @agent.start unless @agent.active?
		response = @session.request request

		puts "\e[1;32mResponse received\e[0m" if DEBUG

		data = case response['content-type']
		when /application\/json/
			JSON.parse response.read_body, symbolize_names: true
		else
			raise "Don't know how to parse #{response['content-type']}"
		end

		unless (200..299).include? response.code.to_i
			raise LifxApi::Error.new request, response, data
		end

		data
	end
end
