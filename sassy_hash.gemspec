# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sassy_hash'

Gem::Specification.new do |spec|
  spec.name          = "sassy_hash"
  spec.version       = SassyHash::VERSION
  spec.authors       = ["Scott Davis"]
  spec.email         = ["me@sdavis.info"]
  spec.description   = %q{SassyHash is a Hash extension that is directly injectable into a Sass::Script::Value::Map}
  spec.summary       = %q{Hash converter for Sass::Script::Value::Map}
  spec.homepage      = "https://github.com/scottdavis/sassy_hash"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "sass", "~> 3.4"
end
