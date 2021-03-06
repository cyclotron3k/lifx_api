# LifxApi [![Build Status](https://travis-ci.org/cyclotron3k/lifx_api.svg?branch=master)](https://travis-ci.org/cyclotron3k/lifx_api)

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

See [LIFX HTTP API](https://api.developer.lifx.com/) for the official documentation.

### list_lights

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.

### set_state

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:power` | string |  |  | The power state you want to set on the selector. Must be `on` or `off`.
`:color` | color |  |  | The color to set the light to. See [color](https://api.developer.lifx.com/docs/colors) documentation on the LIFX website.
`:brightness` | numeric |  |  | The brightness level from 0.0 to 1.0. Overrides any brightness set in color (if any).
`:duration` | numeric |  | 1.0 | How long in seconds you want the power action to take. Range: `0.0` - `3155760000.0` (100 years)
`:infrared` | numeric |  |  | The maximum brightness of the infrared channel from `0.0` to `1.0`.
`:fast` | boolean |  | false | Execute the query fast, without initial state checks and wait for no results.

### set_states

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:states` | array of hashes | &#10004; |  | Array of state hashes as per `#set_state`. No more than 50 entries.
`:defaults` | hash |  |  | Default values to use when not specified in each `states[]` hash.
`:fast` | boolean |  | false | Execute the query fast, without initial state checks and wait for no results.

### state_delta

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:power` | string |  |  | The power state you want to set on the selector. Must be `on` or `off`.
`:duration` | numeric |  | 1.0 | How long in seconds you want the power action to take. Range: `0.0` - `3155760000.0` (100 years)
`:infrared` | numeric |  |  | The maximum brightness of the infrared channel.
`:hue` | numeric |  |  | Rotate the hue by this angle in degrees. Range: `-360.0` - `360.0` degrees.
`:saturation` | numeric |  |  | Change the saturation by this additive amount; the resulting saturation is clipped to `[0, 1]`.
`:brightness` | numeric |  |  | Change the brightness by this additive amount; the resulting brightness is clipped to `[0, 1]`.
`:kelvin` | numeric |  |  | Change the kelvin by this additive amount; the resulting kelvin is clipped to `[2500, 9000]`.

### stage_delta
[DEPRECATED] `#stage_delta` is deprecated, please use `#state_delta` instead

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:power` | string |  |  | The power state you want to set on the selector. Must be `on` or `off`.
`:duration` | numeric |  | 1.0 | How long in seconds you want the power action to take. Range: `0.0` - `3155760000.0` (100 years)
`:infrared` | numeric |  |  | The maximum brightness of the infrared channel.
`:hue` | numeric |  |  | Rotate the hue by this angle in degrees. Range: `-360.0` - `360.0` degrees.
`:saturation` | numeric |  |  | Change the saturation by this additive amount; the resulting saturation is clipped to `[0, 1]`.
`:brightness` | numeric |  |  | Change the brightness by this additive amount; the resulting brightness is clipped to `[0, 1]`.
`:kelvin` | numeric |  |  | Change the kelvin by this additive amount; the resulting kelvin is clipped to `[2500, 9000]`.

### toggle_power

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:duration` | numeric |  | 1.0 | The time is seconds to spend perfoming the power toggle.

### breathe_effect

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:color` | color | &#10004; |  | The color to use for the breathe effect. See [color](https://api.developer.lifx.com/docs/colors) documentation on the LIFX website.
`:from_color` | string |  | current bulb color | The color to start the effect from. If this parameter is omitted then the color the bulb is currently set to is used instead.
`:period` | numeric |  | 1.0 | The time in seconds for one cyles of the effect.
`:cycles` | numeric |  | 1.0 | The number of times to repeat the effect.
`:persist` | boolean |  | false | If `false` set the light back to its previous value when effect ends, if true leave the last effect color.
`:power_on` | boolean |  | true | If `true`, turn the bulb on if it is not already on.
`:peak` | numeric |  | 0.5 | Defines where in a period the target color is at its maximum. Minimum `0.0`, maximum `1.0`.

### move_effect

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:direction` | string |  | forward | Move direction, can be `forward` or `backward`.
`:period` | numeric |  | 1.0 | The time in seconds for one cyles of the effect.
`:cycles` | numeric |  | infinite | The number of times to move the pattern across the device. Special cases are `0` to switch the effect off, and unspecified to continue indefinitely.
`:power_on` | boolean |  | true | Switch any selected device that is off to on before performing the effect.

### morph_effect

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:period` | numeric |  | 5.0 | This controls how quickly the morph runs. It is measured in seconds. A lower number means the animation is faster.
`:duration` | numeric |  | infinite | How long the animation lasts for in seconds. Not specifying a duration makes the animation never stop. Specifying `0` makes the animation stop. Note that there is a known bug where the tile remains in the animation once it has completed if duration is nonzero.
`:palette` | array of colors |  | 7 colours across the spectrum | You can control the colors in the animation by specifying a list of color specifiers. For example `["red", "hue:100 saturation:1"]`.
`:power_on` | boolean |  | true | Switch any selected device that is off to on before performing the effect.

### flame_effect

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:period` | numeric |  | 5.0 | This controls how quickly the flame runs. It is measured in seconds. A lower number means the animation is faster.
`:duration` | numeric |  | infinite | How long the animation lasts for in seconds. Not specifying a duration makes the animation never stop. Specifying `0` makes the animation stop. Note that there is a known bug where the tile remains in the animation once it has completed if duration is nonzero.
`:power_on` | boolean |  | true | Switch any selected device that is off to on before performing the effect.

### pulse_effect

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:color` | string | &#10004; |  | The color to use for the pulse effect. See [color](https://api.developer.lifx.com/docs/colors) documentation on the LIFX website.
`:from_color` | string |  | current bulb color | The color to start the effect from. If this parameter is omitted then the color the bulb is currently set to is used instead.
`:period` | numeric |  | 1.0 | The time in seconds for one cyles of the effect.
`:cycles` | numeric |  | 1.0 | The number of times to repeat the effect.
`:persist` | boolean |  | false | If `false` set the light back to its previous value when effect ends, if true leave the last effect color.
`:power_on` | boolean |  | true | If `true`, turn the bulb on if it is not already on.

### effects_off

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:power_off` | boolean |  | false | If `true`, the devices will also be turned off.

### cycle

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:selector` | selector |  | all | See [selector](https://api.developer.lifx.com/docs/selectors) documentation on the LIFX website.
`:states` | array of hashes | &#10004; |  | Array of state hashes as per `#set_state`. Must have 2 to 5 entries.
`:defaults` | hash |  |  | Default values to use when not specified in each `states[]` object.
`:direction` | direction |  | forward | Direction in which to cycle through the list. Can be `forward` or `backward`.

### list_scenes

*No parameters*

### activate_scene

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:scene_uuid` | uuid | &#10004; |  | The UUID for the scene you wish to activate
`:duration` | numeric |  | 1.0 | The time in seconds to spend performing the scene transition.
`:ignore` | array of strings |  |  | Any of `power`, `infrared`, `duration`, `intensity`, `hue`, `saturation`, `brightness` or `kelvin`, specifying that these properties should not be changed on devices when applying the scene.
`:overrides` | hash |  |  | A state hash as per `#set_state` specifying properties to apply to all devices in the scene, overriding those configured in the scene.

### validate_color

#### Parameters

Key | Type | Mandatory | Default | Description
--- | --- | --- | --- | ---
`:color` | color | &#10004; |  | Color string you'd like to validate. See [color](https://api.developer.lifx.com/docs/colors) documentation on the LIFX website.


## Deviation from the API spec

Some API endpoints require a mandatory [`selector`](https://api.developer.lifx.com/docs/selectors) parameter, which defines which bulbs to apply your action to. This client will default the `selector` parameter to `'all'`, if no selector is provided.

```ruby
# which means that you can call
client.list_bulbs
# ...and receive a hash of all your bulbs back

# instead of having to explicitly specify you want all bulbs:
client.list_bulbs selector: 'all'
```

## Exceptions

If there is an error, `LifxApi` will raise an exception. The exception message will usually give a good indication of what went wrong, but you can also rescue the exception and access the request, response and decoded JSON objects, via the `request`, `response` and `data` methods.

## Development

Run `rake test` to run the tests and `rake console` to start an interactive pry console.

## TODO

* Validation of `:state` and `:array_of_states` is poor
* Validation of `:color` and `:array_of_colors` is poor
* Validation of endpoints is non-existent

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cyclotron3k/lifx_api.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
