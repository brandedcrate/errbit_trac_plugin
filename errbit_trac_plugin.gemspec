# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'errbit_trac_plugin/version'

Gem::Specification.new do |spec|
  spec.name          = 'errbit_trac_plugin'
  spec.version       = ErrbitTracPlugin::VERSION
  spec.authors       = ['Stephen Crosby']
  spec.email         = ['stevecrozz@gmail.com']
  spec.description   = %q{Add Trac issue tracker plugin to errbit}
  spec.summary       = %q{Add Trac issue tracker plugin to errbit}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'errbit_plugin'
  spec.add_dependency 'trac4r', '~> 1.2.4' 

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'jeweler', '~> 2.0.1'
end
