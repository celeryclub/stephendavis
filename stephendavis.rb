require 'sinatra'
require 'data_mapper'
require 'slim'
require 'sass'
require 'coffee-script'
require 'rdiscount'
require 'nokogiri'
# require 'aws/s3'

# TODO
# ----------------------------
# * New 'Projects' header image
# * add full text search
# * reload Last.fm dynamically
# * Change from jQuery to RightJS?
# * Add file upload capability (http://amazon.rubyforge.org/) (http://ididitmyway.heroku.com/past/2011/1/16/uploading_files_in_sinatra/)

# Config
# ----------------------------
set :slim, :pretty => true
MenuItem = Struct.new(:path, :text, :description)
before do
  @recent_posts = Post.all(:fields => [:slug, :title, :published], :order => [:published.desc], :limit => 3)
  @menu_items = [
    MenuItem.new('/','Home',''),
    MenuItem.new('/blog','Blog','Read some pretty good articles.'),
    MenuItem.new('/projects','Projects',"See what I've been up to."),
    MenuItem.new('/about','About','Learn a little bit about me.')
  ]
end

# Models
# ----------------------------
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://root:@127.0.0.1/sinatra_stephendavis')
class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String, :required => true, :unique => true
  property :slug, String, :default => lambda { |r,p| r.slugize } #, :unique => true
  property :published, Date, :required => true
  property :body, Text, :required => true
  def slugize
    title.downcase.gsub(/\W/,'-').squeeze('-').chomp('-')
  end
end
DataMapper.finalize
DataMapper.auto_upgrade!

# Helpers
# ----------------------------
helpers do
  def markdown(md) RDiscount.new(md, :smart).to_html end
  def strip_tags(html) Nokogiri::HTML(html).inner_text end
  def truncate(text, length = 40, end_string = ' &hellip;')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
  def protected!
    if ENV['RACK_ENV'] == 'production'
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      unless @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['ADMIN_USERNAME'], ENV['ADMIN_PASSWORD']]
        response['WWW-Authenticate'] = %(Basic realm='Administration')
        throw(:halt, [401, "Not authorized\n"])
      end
    end
  end
end

# Routes
# ----------------------------
get('/css/application.css') { scss(:'assets/application') }
get('/js/application.js') { coffee(:'assets/application') }

get '/' do
  @title = 'This is the website of Stephen Davis'
  @newest_post = Post.first(:order => [:published.desc])
  slim :index
end
get '/projects' do
  @title = 'Projects'
  slim :projects
end
get '/about' do
  @title = 'About'
  slim :about
end

get '/blog' do
  @posts = Post.all(:order => [:published.desc])
  @title = 'Blog'
  slim :'posts/index'
end
get '/blog/archive' do
  @post_groups = Post.all.inject({}) do |s,p|
    ym = p.published.strftime('%Y-%m')
    s.merge(s[ym] ? {ym=>s[ym]<<p} : {ym=>[p]})
  end.sort {|a,b| b[0] <=> a[0]}
  @title = 'Archive'
  slim :'posts/archive'
end
get '/blog/new' do
  protected!
  @post = Post.new
  @title = 'New Post'
  slim :'posts/form', locals: { new_record: true }
end
post '/blog' do
  protected!
  @post = Post.new(params['post'])
  if @post.save
    redirect to('/blog/' + @post.slug)
  else
    @title = 'New Post'
    slim :'posts/form', locals: { new_record: true }
  end
end
get '/blog/:id/edit' do
  protected!
  if @post = Post.get(params[:id])
    @title = 'Edit Post'
    slim :'posts/form', locals: { new_record: false }
  else
    error 404
  end
end
patch '/blog/:id' do
  protected!
  @post = Post.get(params[:id])
  @post.attributes = params['post']
  if @post.save
    redirect to('/blog/' + @post.slug)
  else
    @title = 'Edit Post'
    slim :'posts/form', locals: { new_record: false }
  end
end
delete '/blog/:id' do
  protected!
  Post.get(params[:id]).destroy
  redirect to('/blog')
end
get '/blog/:slug' do
  if @post = Post.first(:slug => params[:slug])
    @title = @post.title
    @older_post = Post.first(:published.lt => @post.published, :order => [:published.desc])
    @newer_post = Post.first(:published.gt => @post.published, :order => [:published.asc])
    slim :'posts/detail'
  else
    error 404
  end
end

error 404 do
  @title = 'Not Found'
  slim :'404'
end
