# -*- encoding: utf-8 -*-
require File.expand_path('../lib/saxy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michał Szajbe"]
  gem.email         = ["michal.szajbe@gmail.com"]
  gem.description   = %q{}
  gem.summary       = %q{Memory-efficient XML parser}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "saxy"
  gem.require_paths = ["lib"]
  gem.version       = Saxy::VERSION

  gem.add_dependency 'nokogiri'
  gem.add_dependency 'activesupport'
end
