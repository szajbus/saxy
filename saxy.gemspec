# -*- encoding: utf-8 -*-
require File.expand_path('../lib/saxy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michał Szajbe"]
  gem.email         = ["michal.szajbe@gmail.com"]
  gem.description   = %q{Saxy uses SAX parser under the hood, which means that it doesn't load the whole XML file into memory. It goes once though it and yields objects along the way.}
  gem.summary       = %q{Memory-efficient XML parser. Finds object definitions and translates them into Ruby objects.}
  gem.homepage      = "http://github.com/monterail/saxy"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "saxy"
  gem.require_paths = ["lib"]
  gem.version       = Saxy::VERSION

  gem.add_dependency 'nokogiri'
  gem.add_dependency 'activesupport'
end
