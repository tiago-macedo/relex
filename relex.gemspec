# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rlex/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tiago Macedo"]
  gem.email         = [""]
  gem.description   = %q{Implements a simple lexer using a StringScanner}
  gem.summary       = %q{Implements a simple lexer using a StringScanner}
  gem.homepage      = "https://github.com/tiago-macedo/relex"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "relex"
  gem.require_paths = ["lib"]
  gem.version       = Relex::VERSION

  gem.add_development_dependency "rspec"
end
