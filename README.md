# LifxApi

A Ruby client for the LIFX API.

This provides access to the [LIFX HTTP API](https://api.developer.lifx.com/), so it can control your lights from anywhere in the world. It does not implement the [LAN API](https://lan.developer.lifx.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lifx_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lifx_api

## Usage

You'll need to have some LIFX bulbs already setup and configured. Then you will need to obtain an `access_token` from the [LIFX website](https://cloud.lifx.com/sign_in).

```ruby
require 'lifx_api'

access_token = "a1b7349df2a...e213"
client = LifxApi.new access_token
lights = client.list_lights
exit() if lights.count == 0
light_id = lights.first[:id]

client.toggle_power selector: 'all'

client.toggle_power selector: "id:#{light_id}"
```

## Endpoints and parameters

### TODO. See [LIFX HTTP API](https://api.developer.lifx.com/) in the mean time

## Deviation from the API spec

Some API endpoints require a mandatory [`selector`](https://api.developer.lifx.com/docs/selectors) parameter, which defines which bulbs to apply your action to. This client will default the `selector` parameter to `'all`', if no selector is provided.

```ruby
# which means that you can call
client.list_bulbs
# ...and receive a hash of all your bulbs back

# instead of having to explicitly specify you want all bulbs:
client.list_bulbs selector: 'all'
```

## Exceptions

If there is an error, LifxApi will raise an exception. The exception message will usually give a good indication of what went wrong, but you can also rescue the exception and access the request, response and decoded JSON objects, via the `request`, `response` and `data` methods.

## Development

Run `rake test` to run the tests and `rake console` to start an interactive pry console.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cyclotron3k/lifx_api.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
