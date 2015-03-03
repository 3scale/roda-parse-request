# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roda/parse_request/version'

Gem::Specification.new do |spec|
  spec.name          = "roda-parse-request"
  spec.version       = Roda::ParseRequest::VERSION
  spec.authors       = ["Michal Cichra", "Enrique García"]
  spec.email         = ["michal@o2h.cz"]
  spec.summary       = %q{Roda plugin which parses the request body of JSON and url-encoded requests automatically}
  spec.description   = %q{It also accepts custom transformations via configuration.}
  spec.homepage      = "https://github.com/3scale/roda-parse-request"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rack-test"
  spec.add_dependency "roda", "~> 1.3"
end
