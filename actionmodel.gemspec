# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'actionmodel/version'

Gem::Specification.new do |spec|
  spec.name          = 'actionmodel'
  spec.version       = ActionModel::VERSION
  spec.authors       = ['Max Kazarin']
  spec.email         = ['maxkazargm@gmail.com']
  spec.summary       = %q{Model actions extender.}
  spec.description   = %q{ActionModel helps to structure model logic with actions.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
end
