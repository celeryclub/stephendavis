express = require('express')
# stylus = require('stylus')
assets = require('connect-assets')
markdown = require('markdown').markdown

app = express()
app.configure( ->
  # For heroku
  app.set('port', process.env.PORT || 3000)
  app.set('views', "#{__dirname}/views")
  app.set('view engine', 'jade')
  # app.use(express.favicon("#{__dirname}/public/favicon.ico"))
  app.use(express.logger('dev'))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(assets({
    buildDir: './public'
  }))
  app.use((req, res, next) ->
    if (req.header('X-PJAX')) then req.pjax = true
    res.renderPjax = (view, options, fn) ->
      if (req.pjax)
        view = "pjax/#{view}"
      res.render(view, options, fn)
    next()
  )
  # app.use((req, res, next) ->
  #   if !req.pjax && !app.locals.recentPosts
  #     Post.find().sort('published').limit(3).execFind((err, posts) ->
  #       if (err)
  #         return "Error in recent posts query. #{err}"
  #       else
  #         app.locals.recentPosts = posts
  #         next()
  #     )
  # )
  # app.use(stylus.middleware({
  #   src: "#{__dirname}/assets"
  #   dest: "#{__dirname}/public"
  #   # compress: true
  #   # ,
  #   # compile: (str, path) ->
  #     # return stylus(str).set('filename', path).set('compress', true)
  # }))
  app.use(express.static("#{__dirname}/public"))
  # For flash messages
  # app.use(express.cookieParser())
  # app.use(express.session({ secret: 'stephen-davis' }))
  # app.use((req, res, next) ->
  #   session = req.session
  #   messages = session.messages || (session.messages = [])
  #   req.flash = (type, message) ->
  #     messages.push([type, message])
  #   res.locals.messages = messages
  #   next()
  # )
)

# Models
# models = require('./models/init')
# Post = models.Post

# Controllers
staticController = require('./controllers/staticController')
# postsController = require('./controllers/postsController')

# View helpers
app.locals({
  menuItems: [
    {
      "text": "Home",
      "uri": "/"
    },
    {
      "text": "Blog",
      "uri": "/blog",
      "description": "Read some pretty good articles."
    },
    {
      "text": "Projects",
      "uri": "/projects",
      "description": "See what I've been up to."
    },
    {
      "text": "About",
      "uri": "/about",
      "description": "Learn a little bit about me"
    }
  ]
  removeSlash: (string) ->
    string.substr(1)
#   # version: 3
#   # date: (date) ->
#   #   d = new Date(date)
#   #   d.toDateString()
  linkTo: (uri, text, classes = '') ->
    link = "<a href='#{uri}'"
    if (uri.indexOf('http') < 0) then link += " data-pjax"
    if (classes.length) then link += " class='#{classes}'"
    link += ">#{text}</a>"
});


# Routes
app.get('/', staticController.index)
app.get('/projects', staticController.projects)
app.get('/about', staticController.about)

# app.get('/requests', postsController.index)
# # app.get('/requests/:id', postsController.show)
# app.get('/requests/new', postsController.new)
# app.get('/requests/:id([0-9a-f]{24})/edit', postsController.edit)
# app.post('/requests', postsController.create)
# app.put('/requests/:id([0-9a-f]{24})', postsController.update)
# app.delete('/requests/:id([0-9a-f]{24})', postsController.destroy)
# app.put('/requests/sort', postsController.sort)


# In case the browser connects before the database is connected, the
# user will see this message.
found = ['DB Connection not yet established. Try again later. Check the console output for error messages if this persists.']

# createWebpage = (req, res) ->
  

app.listen(app.get('port'), ->
  console.log('http server will be listening on port %d', app.get('port'));
  console.log('CTRL+C to exit');
)