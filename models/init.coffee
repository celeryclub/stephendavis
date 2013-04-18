mongoose = require('mongoose')

uristring = process.env.MONGOHQ_URL || 'mongodb://localhost/stephendavis'
mongoose.connect(uristring, (err, res) ->
  if (err)
    console.log ('ERROR connecting to: ' + uristring + '. ' + err)
  else
    console.log ('Succeeded connected to: ' + uristring)
)

exports.post = require('./post')(mongoose)
