source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.8'
gem 'rails', '~> 5.2.4', '>= 5.2.4.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'dotenv-rails'
  gem 'gimei'
  gem 'rspec-rails'
  gem 'parallel_tests'
  gem 'pre-commit'
  gem 'brakeman'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'meowcop'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
