require 'bundler'
Bundler.require

require './app'
run Sinatra::Application

require 'rack/rewrite'
use Rack::Rewrite do
  r301 %r{^/(.*)/$}, '/$1'

  r301 %r{^/blog/category/.*}, '/blog'
  r301 %r{^/blog/(19|20)\d\d.*}, '/blog/archive'
  # r301 %r{/users(.*)}, '/people$1'
  r301 '/blog/new-album-released', '/blog/new-album-out'
  r301 '/blog/font-face-text-shadow-and-google-chrome', '/blog/font-face-text-shadow-and-chrome'

  r301 '/about-me', '/about'
  r301 '/portfolio', '/projects'
  r301 '/music', '/about'
  r301 '/contact', '/about'
end
