source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.3", ">= 6.0.3.3"
# Use postgresql as the database for Active Record
gem "pg"
# Use Puma as the app server
gem "activesupport", "6.0.3.3"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", "1.4.8", require: false
gem "config", "2.2.1"
gem "devise"
gem "dotenv-rails"
gem "dry-core", "0.4.9"
gem "dry-initializer", "3.0.3"
gem "dry-logic", "1.0.7"
gem "dry-schema", "1.5.4"
gem "dry-validation", "1.5.6"
gem "erubi", "1.9.0"
gem "faker", "2.14.0"
gem "grape", "1.4.0"
gem "grape-entity", "0.8.1"
gem "grape_on_rails_routes"
gem "i18n"
gem "jbuilder", "~> 2.7"
gem "jwt"
gem "loofah", "2.7.0"
gem "parallel", "1.19.2"
gem "parser", "2.7.1.5"
gem "paypal-sdk-rest"
gem "puma", "4.3.6"
gem "rack-cors"
gem "redis", "4.2.2"
gem "regexp_parser", "1.8.0"
gem "sidekiq"
gem "tzinfo", "1.2.7"
gem "zeitwerk", "2.4.0"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem "pry-rails"
end

group :development do
  gem "listen", "~> 3.2.1"
  gem "rails_best_practices"
  gem "rubocop", "0.92.0", require: false
  gem "rubocop-ast", "0.6.0"
  gem "rubocop-rails", "~> 2.3.2", require: false
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
