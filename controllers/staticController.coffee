exports.index = (req, res) ->
  # Request.find().sort('position').execFind((err, post) ->
    # if (err)
      # res.end("Error in query. #{err}")
    # else
      res.renderPjax('index', {
        title: 'This is the homepage'
        # post: post
      })
  # )

exports.projects = (req, res) ->
  res.renderPjax('projects', {
    title: 'Projects'
  })

exports.about = (req, res) ->
  res.renderPjax('about', {
    title: 'About'
  })
