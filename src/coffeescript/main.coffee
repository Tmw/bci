require 'jQuery'


servers       = null
connection    = optional: [RtpDataChannels: true]
pc1           = new webkitRTCPeerConnection servers, connection
pc2           = new webkitRTCPeerConnection servers, connection
sendChannel   = pc1.createDataChannel "sendDataChannel", reliable: false
receiveChannel = null

sendChannel.onopen = ->
  console.log 'sendchannel readystate: ' + sendChannel.readyState
  sendChannel.send('nice')

sendChannel.onclose = ->
  console.log 'sendchannel readystate: ' + sendChannel.readyState

pc1.onicecandidate = (event) ->
  if event.candidate
    pc2.addIceCandidate event.candidate
    console.log 'local ICE candidate:' + event.candidate.candidate

pc2.onicecandidate = (event) ->
  if event.candidate
    pc1.addIceCandidate event.candidate
    console.log 'remote ICE candidate:' + event.candidate.candidate

pc1.createOffer (desc) ->
  pc1.setLocalDescription desc
  pc2.setRemoteDescription desc

  pc2.createAnswer (desc) ->
    pc2.setLocalDescription desc
    pc1.setRemoteDescription desc

sendChannel.onmessage = (event) ->
  console.log 'OMG! OMG! OMG! HE RESPONDED!' + event.data

pc2.ondatachannel = (event) ->
  receiveChannel = event.channel
  receiveChannel.onmessage = (event) ->

    console.log 'ZOMG!!!! I GOT DATA!!: '+ event.data
    receiveChannel.send('RIGHT BACK AT YA!')




