Request = require('../models/request')

exports.index = (req, res) ->
  Request.find().sort('position').execFind((err, requests) ->
    if (err)
      res.end("Error in index query. #{err}")
    else
      if (req.accepts('html, json') == 'json')
        res.json(requests)
      else
        res.render('requests/index', {
          title: 'Requests'
          requests: requests
        })
  )

# exports.show = (req, res) ->
#   Request.findOne({_id: req.params.id}, (err, request) ->
#     if (err)
#       res.end("Error in show query. #{err}")
#     else
#       res.render('requests/form', {
#         title: request.title
#         request: request
#       })
#   )

exports.new = (req, res) ->
  res.render('requests/form', {
    title: 'New request'
    request: new Request()
  })

exports.edit = (req, res) ->
  Request.findOne({_id: req.params.id}, (err, request) ->
    if (err)
      res.end("Error in edit query. #{err}")
    else
      res.render('requests/form', {
        title: 'Edit request'
        request: request
      })
  )

exports.create = (req, res) ->
  request = new Request (req.body)
  request.save((err) ->
    if (err)
      res.render('requests/form', {
        title: request.title
        request: request
        # 'errors' => $article->errors
      })
      console.log ("Error on save: #{err}")
      console.log ("count: #{err.errors.title.value}")
      # console.log ("Errors: #{err.errors}")
      # messages = {}
      # messages[name] = 
      # console.log ("Type: #{error.type}") for error in err.errors
    else
      req.flash(['success', 'Request created successfully.'])
      res.redirect('/requests')
  )

exports.update = (req, res) ->
  Request.findByIdAndUpdate(req.params.id, req.body, (err) ->
    if (err)
      res.end("Error in update query. #{err}")
    else
      req.flash(['success', 'Request updated successfully.'])
      res.redirect('/requests')
  )

exports.destroy = (req, res) ->
  Request.findByIdAndRemove(req.params.id, req.body, (err) ->
    if (err)
      res.end("Error in delete query. #{err}")
    else
      req.flash(['success', 'Request deleted successfully.'])
      res.redirect('/requests')
  )

exports.sort = (req, res) ->
  console.log(req.body.requests)
  for request_id, i in req.body.requests
    console.log("#{i} = #{request_id}")
    Request.findByIdAndUpdate(request_id, { position: i + 1 }, (err) ->
      if (err)
        res.end("Error in sort query. #{err}")
      else
        ''
    )
