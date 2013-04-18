express = require('express.io')
fs      = require('fs')
app     = express()

# internal lists
playerIDs     = []
playerSockets = {}

# Spawn a HTTP and an IO-server
app.http().io()

# set static's dir
app.configure -> app.use(express.static(__dirname + '/../build/'))

# we only have one route for now
app.get '/', (req, res) ->
  fs.readFile __dirname + '/../build/index.html', 'utf8', (err, text) ->
    res.send text

# listen on port 8080
app.listen 8080


### ###############
# TODO: seriously refactor this!
### ###############




# if a connection accoured
app.io.route 'subscribe', (req) ->
  req.io.join 'users'
  
  # add myself to the players list
  userObj =
    id:       req.socket.id
    username: req.data.username

  # let other know we are in tha house
  req.io.room('users').broadcast('users:add', JSON.stringify(userObj))

  # save internal reference
  playerIDs.push userObj

  # and store a reference to my socket
  playerSockets[req.socket.id] = req.socket

  # send back a list of already present users
  req.io.emit 'users:list', JSON.stringify(playerIDs)

  req.socket.on 'disconnect', ->
    # get ID of socket
    id = req.socket.id

    # remove player from playerIDs list
    pid_index = playerIDs.indexOf(userObj)
    playerIDs.splice(pid_index, 1)

    # remove from internal socket list
    delete playerSockets[id]

    # leave room
    req.io.leave('users')

    # inform others i've left
    req.io.room('users').broadcast('users:remove', JSON.stringify(userObj))

# yep.
console.log 'Server running on port 8080'







