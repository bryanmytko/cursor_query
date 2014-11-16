$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cursor_query/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cursor_query"
  s.version     = CursorQuery::VERSION
  s.authors     = ["Bryan Mytko"]
  s.email       = ["bryanmytko@gmail.com"]
  s.homepage    = "http://www.bryanmytko.com"
  s.summary     = "Cursored querying for ActiveRecrd"
  s.description = "Created cursored queries for rapidly changing data feeds."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.4"

  s.add_development_dependency "sqlite3"

  s.test_files = Dir["spec/**/*"]
end
