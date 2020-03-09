# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lifx_api/version"

Gem::Specification.new do |spec|
	spec.name          = "lifx_api"
	spec.version       = LifxApi::VERSION
	spec.authors       = "cyclotron3k"

	spec.summary       = "A client for the LIFX HTTP API"
	spec.homepage      = "https://github.com/cyclotron3k/lifx_api"
	spec.license       = "MIT"

	spec.files         = `git ls-files -z`.split("\x0").reject do |f|
		f.match(%r{^(test|spec|features)/})
	end

	spec.require_paths = ["lib"]

	spec.add_development_dependency "minitest", "~> 5.0"
	spec.add_development_dependency "pry", "~> 0.10"
end
