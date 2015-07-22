# -*- encoding: utf-8 -*-
VERSION = "1.0"

Gem::Specification.new do |spec|
  spec.name          = "motion-carthage"
  spec.version       = VERSION
  spec.authors       = ["Doug"]
  spec.description   = "Carthage support for RubyMotion"
  spec.summary       = "Carthage support for RubyMotion"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
end
