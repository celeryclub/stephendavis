source 'http://rubygems.org'
ruby '2.1.4'

gem 'sinatra', '1.4.5'
gem 'data_mapper'
gem 'thin'
gem 'slim'
gem 'sass'
gem 'coffee-script'
gem 'rdiscount'
gem 'nokogiri'
gem 'rack-rewrite', :require => 'rack/rewrite'

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end

group :development do
  gem 'mysql2'
  gem 'dm-mysql-adapter'
end
