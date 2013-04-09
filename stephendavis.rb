require 'sinatra'
require 'data_mapper'
# require 'dm_ferret_adapter'
# require 'dm_is_searchable'
# require 'dm-ferret-adapter'
# require 'dm-is-searchable'
require 'slim'
require 'sass'
require 'coffee-script'
require 'rdiscount'
require 'nokogiri'
# require 'aws/s3'



# Config
# ----------------------------
set :slim, :pretty => true
MenuItem = Struct.new(:path, :text, :description)
before do
  @recent_posts = Post.all(:fields => [:slug, :title, :published], :order => [:published.desc], :limit => 3)
end


# Models
# ----------------------------
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://root:@127.0.0.1/sinatra_stephendavis')
# DataMapper.setup(:search, :adapter => 'ferret')
class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String, :required => true, :unique => true
  property :slug, String, :default => lambda { |r,p| r.slugize } #, :unique => true
  property :published, Date, :required => true
  property :body, Text, :required => true
  # is :searchable
  # repository(:search) do
  #   properties(:search).clear
  #   property :title, String
  #   property :body, Text
  # end
  def slugize
    title.downcase.gsub(/\W/,'-').squeeze('-').chomp('-')
    # title.downcase.gsub(' ', '-').gsub(/\W/,'')
  end
  # Post.search(:query => params[:query], :fields => [:title, :body])
  def self.search(params, options = {})
    query = params[:query]
    fields = params[:fields]
    searchables = fields.map { |field| self.send(field.to_s) }
    # self.all({:slug.not => 'home'}.merge(options))
    posts = self.all(:order => [:published.desc])
    # results = []
    # posts.each do |post|
      # results << post.body
    # end
    # posts.collect { |k, v| "#{k.title}=#{v} " }.join
    w = []
    # results = []
    results = posts.select do |post|
    # posts.each do |post|
      # words = []
      # post.body.split
      # titles << post.title
      # titles << post.title.split(' ')
      # post.title.split(' ').each { |word| titles << word }

      # post.title.split(' ').each { |word| words << word.downcase }
      words = []
      searchables.each do |field|
        post.send(field.name).split(' ').each { |word| words << word.downcase.gsub(/\W/,'') }
        # w << post.send(field.name)
      end
      # w << post.title.split(' ').map { |word| word.downcase }
      w << words
      # query.split('+').all? { |term| words.include?(term.downcase.gsub(/\W/,'')) }
      query.split('+').all? { |term| words.any? { |word| word =~ /#{term.downcase.gsub(/\W/,'')}/ } }
      # titles << words << query
      # words.include?(query)
      # if words.include?(query)
        # results << post
        # results << query
      # end
      # titles << words.include?(query).class
      # titles << query.split('+')
      # query.split('+').each do |term|
        # titles << term
      # end
    end
    results
    # query.split('+')
    # w
    # searchables
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
get('/css/app.css') { scss(:'assets/app') }
get('/js/app.js') { coffee(:'assets/app') }



get '/blog' do
  @title = 'Blog'
  @posts = Post.all(:order => [:published.desc])
  slim :'posts/index'
end
get '/blog/archive' do
  @title = 'Archive'
  @post_groups = Post.all.inject({}) do |s,p|
    ym = p.published.strftime('%Y-%m')
    s.merge(s[ym] ? {ym=>s[ym]<<p} : {ym=>[p]})
  end.sort {|a,b| b[0] <=> a[0]}
  slim :'posts/archive'
end
get '/blog/search/:query' do
  @title = 'Search'
  # @query = "%#{params[:query].gsub('+', '%')}%"
  # @posts = Post.all(:title.like => @query) | Post.all(:body.like => @query)
  # results.inspect
  # @title = @post.title
  @query = params[:query] #.gsub('+', ' ')
  # Post.search(:field_blah => 'value', :attribute_blah => 'value', default_options_hash)
  @results = Post.search(:query => @query, :fields => [:title, :body]) #, default_options_hash)
  slim :'posts/results'
  # htms = query.inspect
  # htms += '<br>'
  # htms += @posts.collect { |k, v| "#{k.title}=#{v} " }.join
end
get '/blog/new' do
  protected!
  @title = 'New Post'
  @post = Post.new
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
