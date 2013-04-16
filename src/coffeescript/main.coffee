require 'jQuery'
ConnectionWrapper = require './lib/ConnectionWrapper'


p1 = new ConnectionWrapper
  onIceCandidate: (event) ->
    p2.addIceCandidate(event.candidate) if event.candidate

  onMessage: (event) ->
    console.log '1 data, lekkah: ', event


p2 = new ConnectionWrapper
  onIceCandidate: (event) ->
    p1.addIceCandidate(event.candidate) if event.candidate

  onMessage: (event) ->
    console.log '2 data, lekkah: ', event    

p1.createSession (details) ->

  # we should be able to send the details over XHR
  detailsJSON = JSON.stringify(details)
  $("#info").text('Offer : '+ detailsJSON)

  # Pretend we are a different PeerClient
  p2.joinSession details, (answer) ->
    p1.handshake answer