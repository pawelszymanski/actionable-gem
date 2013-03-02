# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'actionable/version'

Gem::Specification.new do |gem|
  gem.name          = "actionable"
  gem.version       = Actionable::VERSION
  gem.authors       = ["Paweł Szymański"]
  gem.email         = ["pawel.szymanski@emention.pl"]
  gem.description   = %q{actionable gem description}
  gem.summary       = %q{actionable gem summary}
  gem.homepage      = "http://theactionable.pl"

  gem.files         = Dir["{lib,app}/**/*"] + ["LICENSE.txt", "README.md"]
  gem.add_dependency "railties", "~> 3.1"
  gem.require_paths = ["lib"]
end
