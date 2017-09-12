class LifxApi
	class Error < StandardError
		attr_reader :request, :response, :data

		def initialize(request, response, data=nil)
			@request = request
			@response = response
			@data = data
			message = if data.is_a?(Hash) and data.key? :error
				"#{response.code} - #{data[:error]}"
			else
				"#{response.code}"
			end
			super message
		end
	end
end
