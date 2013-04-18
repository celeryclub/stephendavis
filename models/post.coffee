module.exports = (mongoose) ->
  postSchema = new mongoose.Schema({
    published: {
      type: Date
      default: Date.now
    }
    title: {
      type: String
      required: true
    }
    slug: {
      type: String
      required: true
      trim: true
    }
    body: {
      type: String
      required: true
    }
  })

  return mongoose.model('posts', postSchema)
