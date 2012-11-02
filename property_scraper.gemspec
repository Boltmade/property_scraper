# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'property_scraper/version'

Gem::Specification.new do |gem|
  gem.name          = "property_scraper"
  gem.version       = PropertyScraper::VERSION
  gem.authors       = ["Ben Morris"]
  gem.email         = ["ben@bnmrrs.com"]
  gem.description   = %q{Scrape ALLLL of the properties}
  gem.summary       = %q{Scrape ALLL of the properties}
  gem.homepage      = "https://github.com/ArtBarn/property_scraper"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("nokogiri")
end
