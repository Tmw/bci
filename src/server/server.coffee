express         = require 'express.io'
fs              = require 'fs'
UserCollection  = require './user_collection'

class Server
  # internal lists
  dist_location:      __dirname + '/../../dist/'

  constructor: ->
    # initialize new UserCollection
    @UserCollection = new UserCollection()

    # initialize Express.io
    @app            = express()

    # Spawn a HTTP and an IO-server
    @app.http().io()

    # configure statics dir
    @app.configure => 
      @app.use(express.static(@dist_location))

    # setup listeners
    @UserCollection.setupListeners(@app)

    # serve main index file
    @app.get '/', (req, res) =>
      fs.readFile @dist_location + 'index.html', (err, content) ->
        res.end content

  start: (port=8080)->
    # listen on port 8080
    @app.listen port

    # let the user know
    console.log 'Server running on port ' + port

# initialize and start the server
new Server().start(8080)






