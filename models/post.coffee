mongoose = require('mongoose')

# Here we find an appropriate database to connect to, defaulting to
# localhost if we don't find one.
uristring = process.env.MONGOHQ_URL || 'mongodb://localhost/prayer_cards'

# Makes connection asynchronously.  Mongoose will queue up database
# operations and release them when the connection is complete.
mongoose.connect(uristring, (err, res) ->
  if (err)
    console.log ('ERROR connecting to: ' + uristring + '. ' + err)
  else
    console.log ('Succeeded connected to: ' + uristring)
)




# This is the schema. Note the types, validation and trim
# statements. They enforce useful constraints on the data.
requestSchema = new mongoose.Schema({
  date: {
    type: Date
    default: Date.now
  }
  title: {
    type: String
    required: true
  }
  position: {
    type: Number,
    # default: ->
    #   mongoose.model('requests', requestSchema).find().select('position').sort('-position').limit(1).execFind((err, request) ->
    #     if (err)
    #       console.log("Error in position fetch. #{err}")
    #     else
    #       console.log(request)
    #       request ? request.position + 1 : 1
    #   )
  }
  details: { type: String }
  # name: {
  #   first: String,
  #   last: { type: String, trim: true }
  # },
  # age: { type: Number, min: 0}
})

requestSchema.pre('save', (next) ->
  // Set the position
  if (!isset($this->position)) {
    $last_article = Model::factory('Article')->order_by_desc('position')->select('position')->find_one();
    $this->position = ($last_article) ? $last_article->position + 1 : 1;
  }
  # console.log('%s has been validated (but not saved yet)', doc._id)
  next()
)

# Compiles the schema into a model, opening (or creating, if
# nonexistent) the 'PowerUsers' collection in the MongoDB database
module.exports = mongoose.model('requests', requestSchema)
