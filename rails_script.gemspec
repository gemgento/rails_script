# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_script/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_script'
  spec.version       = RailsScript::VERSION
  spec.authors       = ['Kevin Pheasey']
  spec.email         = ['kevin.pheasey@gmail.com']
  spec.summary       = %q{A Rails-centric, object oriented, featherweight framework for writting CoffeeScript}
  spec.description   = %q{Rails Script is a Rails-centric, object oriented, featherweight framework for writting CoffeeScript. It is optomized for the Rails Asset Pipeline and is compatible with TurboLinks. Using Rails controller names and actions to call JavaScript, it has never been easier to write clean, concise, and maintanable page specific JavaScript.}
  spec.homepage      = 'https://github.com/gemgento/rails_script'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\u0000")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 0'

  spec.add_dependency 'coffee-rails', '~> 4.0', '>= 4.0.0'
end
