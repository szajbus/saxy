# -*- encoding: utf-8 -*-
require File.expand_path('../lib/saxy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michał Szajbe"]
  gem.email         = ["michal.szajbe@gmail.com"]
  gem.description   = %q{Saxy finds object definitions in XML files and translates them into Ruby objects. It uses SAX parser under the hood, which means that it doesn't load the whole XML file into memory. It goes once through it and yields objects along the way.}
  gem.summary       = %q{Memory-efficient XML parser. Finds object definitions and translates them into Ruby objects.}
  gem.homepage      = "http://github.com/humante/saxy"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "saxy"
  gem.require_paths = ["lib"]
  gem.version       = Saxy::VERSION

  gem.required_ruby_version = ">= 1.9.3"

  gem.add_dependency "nokogiri", "1.6.8.1"

  gem.add_development_dependency "rspec"
end
