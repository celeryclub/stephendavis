source :rubygems

ruby '1.9.3'

gem 'sinatra'
gem 'data_mapper'
gem 'slim'
gem 'thin'
gem 'sass'
gem 'coffee-script'
gem 'rdiscount'
gem 'nokogiri'
# gem 'aws-s3', :require => 'aws/s3'
gem 'rack-rewrite', :require => 'rack/rewrite'

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end

group :development do
  gem 'mysql2'
  gem 'dm-mysql-adapter'
end
