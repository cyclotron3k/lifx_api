class LifxApi
	ENDPOINTS = [{
		method_name: :list_lights,
		http_method: :get,
		path: '/v1/lights/%{selector}',
		path_params: {
			selector: {required: true, type: :selector, default: 'all'},
		},
	}, {
		method_name: :set_state,
		http_method: :put,
		path: '/v1/lights/%{selector}/state',
		path_params: {
			selector: {required: true, type: :selector, default: 'all'},
		},
		body_params: {
			power: {type: :string, description: 'The power state you want to set on the selector. on or off'},
			color: {type: :string, description: 'The color to set the light to.'},
			brightness: {type: :numeric, description: 'The brightness level from 0.0 to 1.0. Overrides any brightness set in color (if any).'},
			duration: {type: :numeric, default_description: '1.0', description: 'How long in seconds you want the power action to take. Range: 0.0 - 3155760000.0 (100 years)'},
			infrared: {type: :numeric, description: 'The maximum brightness of the infrared channel.'},
		},
	}, {
		method_name: :set_states,
		http_method: :put,
		path: '/v1/lights/states',
		body_params: {
			states: {required: true, type: :array_of_states},
			defaults: {type: :hash},
		},
	}, {
		method_name: :stage_delta,
		http_method: :post,
		path: '/v1/lights/%{selector}/state/delta',
		path_params: {
			selector: {required: true, type: :selector, default: 'all'}
		},
		body_params: {
			power: {type: :on_off, description: 'The power state you want to set on the selector. on or off'},
			duration: {type: :numeric, default_description: '1.0', description: 'How long in seconds you want the power action to take. Range: 0.0 - 3155760000.0 (100 years)'},
			infrared: {type: :numeric, description: 'The maximum brightness of the infrared channel.'},
			hue: {type: :numeric, description: 'Rotate the hue by this angle in degrees.'},
			saturation: {type: :numeric, description: 'Change the saturation by this additive amount; the resulting saturation is clipped to [0, 1].'},
			brightness: {type: :numeric, description: 'Change the brightness by this additive amount; the resulting brightness is clipped to [0, 1].'},
			kelvin: {type: :numeric, description: 'Change the kelvin by this additive amount; the resulting kelvin is clipped to [2500, 9000].'},
		},
	}, {
		method_name: :toggle_power,
		http_method: :post,
		path: '/v1/lights/%{selector}/toggle',
		path_params: {
			selector: {required: true, type: :selector, default: 'all'},
		},
		body_params: {
			duration:	{type: :numeric, default_description: '1.0', description: 'The time is seconds to spend perfoming the power toggle.'},
		},
	}, {
		method_name: :breathe_effect,
		http_method: :post,
		path: '/v1/lights/%{selector}/effects/breathe',
		path_params: {
			selector: {required: true, type: :selector, default: 'all'},
		},
		body_params: {
			color: {required: :true, type: :string, description: 'The color to use for the breathe effect.'},
			from_color:	{type: :string, default_description: 'current bulb color', description: 'The color to start the effect from. If this parameter is omitted then the color the bulb is currently set to is used instead.'},
			period: {type: :numeric, default_description: '1.0', description: 'The time in seconds for one cyles of the effect.'},
			cycles: {type: :numeric, default_description: '1.0', description: 'The number of times to repeat the effect.'},
			persist: {type: :boolean, default_description: 'false', description: 'If false set the light back to its previous value when effect ends, if true leave the last effect color.'},
			power_on: {type: :boolean, default_description: 'true', description: 'If true, turn the bulb on if it is not already on.'},
			peak: {type: :numeric, default_description: '0.5', description: 'Defines where in a period the target color is at its maximum. Minimum 0.0, maximum 1.0.'},
		}
	}, {
		method_name: :pulse_effect,
		http_method: :post,
		path: '/v1/lights/%{selector}/effects/pulse',
		path_params: {
			selector: {required: true, type: :selector, default: 'all'},
		},
		body_params: {
			color: {required: true, type: :string, description: 'The color to use for the pulse effect.'},
			from_color: {type: :string, default_description: 'current bulb color', description: 'The color to start the effect from. If this parameter is omitted then the color the bulb is currently set to is used instead.'},
			period: {type: :numeric, default_description: '1.0', description: 'The time in seconds for one cyles of the effect.'},
			cycles: {type: :numeric, default_description: '1.0', description: 'The number of times to repeat the effect.'},
			persist: {type: :boolean, default_description: 'false', description: 'If false set the light back to its previous value when effect ends, if true leave the last effect color.'},
			power_on: {type: :boolean, default_description: 'true', description: 'If true, turn the bulb on if it is not already on.'},
		}
	}, {
		method_name: :cycle,
		http_method: :post,
		path: '/v1/lights/%{selector}/cycle',
		body_params: {
			states: {required: true, type: :array_of_states, description: 'Array of state hashes as per Set State. Must have 2 to 5 entries.'},
			defaults: {type: :state, description: 'Default values to use when not specified in each states[] object.'},
			direction: {type: :direction, description: 'Direction in which to cycle through the list. Can be forward or backward'},
		}
	}, {
		method_name: :list_scenes,
		http_method: :get,
		path: '/v1/scenes',
	}, {
		method_name: :activate_scene,
		http_method: :put,
		path: '/v1/scenes/scene_id:%{scene_uuid}/activate',
		path_params: {
			scene_uuid: {required: true, type: :uuid, description: 'The UUID for the scene you wish to activate'},
		},
		body_params: {
			duration: {type: :numeric, default_description: '1.0', description: 'The time in seconds to spend performing the scene transition.'},
			ignore: {type: :ignore_array, description: 'Any of "power", "infrared", "duration", "intensity", "hue", "saturation", "brightness" or "kelvin", specifying that these properties should not be changed on devices when applying the scene.'},
			overrides: {type: :state, description: 'A state object as per Set State specifying properties to apply to all devices in the scene, overriding those configured in the scene.'},
		}
	}, {
		method_name: :validate_color,
		http_method: :put,
		path: '/v1/color',
		query_params: {
			color: {type: :string, required: true},
		},
	}]
end
