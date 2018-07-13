$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "clickety/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "clickety"
  s.version     = Clickety::VERSION
  s.authors     = ["Tim Hansen", "Kris Utter"]
  s.email       = ["tim@vianetmgt.com", "kris@vianetmgt.com"]
  s.homepage    = 'http://rubygems.org/gems/clickety'
  s.summary     = 'Clickety API Integration'
  s.description = 'Gem for interacting with the Clickety API'
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", '~> 4.0', '>= 4.0.0'
end
