$:.unshift File.expand_path("../lib", __FILE__)
require 'sinatra/tag-helpers/version'

Gem::Specification.new do |spec|
  spec.name          = "sinatra-tag-helpers"
  spec.version       = Sinatra::TagHelpers::VERSION
  spec.authors       = ["Evan Lecklider"]
  spec.email         = ["evan.lecklider@gmail.com"]
  spec.description   = %q{Tag helpers (links and input tags) for Sinatra}
  spec.summary       = spec.description
  spec.homepage      = ""

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra', '~> 1.4.0'
  spec.add_dependency 'escape_utils', '>= 0.3.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
