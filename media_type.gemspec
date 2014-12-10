# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'media_type'

Gem::Specification.new do |spec|
  spec.name          = "media_type"
  spec.version       = MediaType::VERSION
  spec.authors       = ["Alyssa Ross"]
  spec.email         = ["hi@alyssa.is"]
  spec.summary       = %q{A library for parsing and generating Internet Media (MIME) Types}
  spec.homepage      = "https://github.com/alyssais/media_type"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
