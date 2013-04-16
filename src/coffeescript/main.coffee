require 'jQuery'
ConnectionWrapper = require './lib/ConnectionWrapper'

$ ->
  #connection = new ConnectionWrapper()

  $('[name=join]').click ->
    console.log 'join clicked'



  $('[name=create]').click ->
    console.log 'create clicked'




# p1 = new ConnectionWrapper
#   onIceCandidate: (event) ->
#     p2.addIceCandidate(event.candidate) if event.candidate

#   onMessage: (event) ->
#     console.log 'RECEIVED 1: '+ event.data
#     setTimeout ->
#       p1.send('yoo.')
#     , 2000



# p1.createSession (details) ->

#   # we should be able to send the details over XHR
#   detailsJSON = JSON.stringify(details)
#   $("#info").text('Offer : '+ detailsJSON)

#   # Pretend we are a different PeerClient
#   p2.joinSession details, (answer) ->
#     p1.handshake answer

# setTimeout ->
#   p1.send("MOTHAFOCKA!")
# , 5000