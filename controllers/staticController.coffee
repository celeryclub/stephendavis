models = require('../models/init')

exports.index = (req, res) ->
  models.post.findOne({}).sort('published').exec((err, post) ->
    if (err)
      res.end("Error in homepage query. #{err}")
    else
      res.renderPjax('index', {
        title: 'This is the homepage'
        latestPost: post
      })
  )

exports.projects = (req, res) ->
  res.renderPjax('projects', {
    title: 'Projects'
  })

exports.about = (req, res) ->
  res.renderPjax('about', {
    layout: false
    title: 'About'
  })
