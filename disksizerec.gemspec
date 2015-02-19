# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'disksizerec/version'

Gem::Specification.new do |spec|
  spec.name          = "disksizerec"
  spec.version       = Disksizerec::VERSION
  spec.authors       = ["Effective Solutions Corporation"]
  spec.email         = ["itservice@efsolmail.com"]
  spec.summary       = %q{DiskSizeRec is a tool to record disk sizes to MongoDB.}
  spec.description   = %q{DiskSizeRec is a tool to record disk sizes to MongoDB.}
  spec.homepage      = "https://github.com/efsol/disksizerec"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "thor"
end
