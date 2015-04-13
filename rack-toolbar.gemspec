# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/toolbar/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-toolbar"
  spec.version       = Rack::Toolbar::VERSION
  spec.authors       = ["Peter Boling"]
  spec.email         = ["peter.boling@gmail.com"]

  spec.summary       = %q{Provides an easy way to create Rack Middleware Toolbars}
  spec.description   = %q{Extracted from rack-insight. Provides an easy way to create Rack Middleware Toolbars}
  spec.homepage      = "https://github.com/pboling/rack-toolbar"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "pry", "~> 0.10"
end
