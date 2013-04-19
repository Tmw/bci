express = require('express.io')
fs      = require('fs')

class Server
  # internal lists
  playerSockets:      {}
  playerIDs:          []

  playerCollection  = []

  constructor: ->
    # initialize Express.io
    @app     = express()

    # Spawn a HTTP and an IO-server
    @app.http().io()

    # configure statics dir
    @app.configure => 
      @app.use(express.static(__dirname + '/../build/'))

    # setup listeners
    @setupListeners()

  start: (port=8080)->
    # listen on port 8080
    @app.listen port

    # let the user know
    console.log 'Server running on port ' +port

 


# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!! TODO: seriously refactor this!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


  findPlayerWithId: (id, callback) ->
    index = 0
    while index < @playerIDs.length
      player = @playerIDs[index]
      if player.id is id
        callback player
      index++

  setupListeners: ->

    # if a connection accoured
    @app.io.route 'subscribe', (req) =>
      req.io.join 'users'
      
      # add myself to the players list
      userObj =
        id:       req.socket.id
        username: req.data.username

      # let other know we are in tha house
      req.io.room('users').broadcast('users:add', JSON.stringify(userObj))

      # save internal reference
      @playerIDs.push userObj

      # and store a reference to my socket
      @playerSockets[req.socket.id] = req.socket

      # send back a list of already present users
      req.io.emit 'users:list', JSON.stringify(@playerIDs)

      req.socket.on 'users:challenge:new', (data) ->
        console.log 'new data', data
        dataobj = JSON.parse data
        socket  = @playerSockets[dataobj.user.id]

        @findPlayerWithId dataobj.user.id, (player) ->
          packet = JSON.stringify('user':player, 'from':dataobj.from, 'handshake':dataobj.handshake)
          socket.emit 'users:challenge:new', packet

      req.socket.on 'users:challenge:finish', (data) ->
        console.log 'finish data', data
        dataobj = JSON.parse data
        socket  = playerSockets[dataobj.user.id]

        findPlayerWithId dataobj.user.id, (player) ->
          packet = JSON.stringify('user':player, 'handshake':dataobj.handshake)
          socket.emit 'users:challenge:finish', packet



      req.socket.on 'disconnect', =>
        # get ID of socket
        id = req.socket.id

        # remove player from playerIDs list
        pid_index = @playerIDs.indexOf(userObj)
        @playerIDs.splice(pid_index, 1)

        # remove from internal socket list
        delete @playerSockets[id]

        # leave room
        req.io.leave('users')

        # inform others i've left
        req.io.room('users').broadcast('users:remove', JSON.stringify(userObj))



# initialize and start the server
new Server().start(8080)






