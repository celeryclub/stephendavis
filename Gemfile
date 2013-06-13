source :rubygems

ruby '2.0.0'

gem 'sinatra'
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
