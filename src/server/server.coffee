express = require('express.io')
fs      = require('fs')
app     = express()
players = []

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

app.io.route 'ready', (req) ->
  players.push req
  req.io.emit 'data', sydney: 'ik heb moneys G!!'

console.log 'Server running on port 8080'