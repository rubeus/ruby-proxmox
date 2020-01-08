source 'https://rubygems.org'

# Specify your gem's dependencies in ruby-proxmox.gemspec
gemspec

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'

  gem 'growl' if RUBY_PLATFORM =~ /darwin/
  gem 'wdm' if RUBY_PLATFORM =~ /mingw/
  gem 'ruby_gntp' if RUBY_PLATFORM =~ /mingw/

  gem 'guard-spork'

  gem 'yard'
  gem 'redcarpet'
  gem 'guard-yard'
end

group :test do
  gem 'spork'
  gem 'simplecov'
  gem 'json'
  gem 'coveralls'
end
