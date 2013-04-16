module.exports = class ConnectionWrapper

  # optional configuration
  servers:        null
  connection:     {optional: [RtpDataChannels: true]}

  constructor: (@options) ->
     @_polyFill()

     # setup PeerConnection and open DataChannel
     @peerConnection = new RTCPeerConnection @servers, @connection

     # setup listeners
     @_setupListeners()

  createSession: (callback) ->
    # first setup a new datachannel
    @dataChannel    = @peerConnection.createDataChannel "dc", reliable: false

    # setup listeners for datachannel
    @_setupDCListeners()

    # pass the thingy
    @_createOffer callback

  joinSession: (details, callback) ->
    @peerConnection.setRemoteDescription details
    @_createAnswer callback

  send: (msg) ->
    if @dataChannel.readyState is "open"
      @dataChannel.send(msg)

  handshake: (desc) ->
    # pointer to the remote datachannel of the other peer
    @peerConnection.setRemoteDescription desc

  addIceCandidate: (candidate) ->
    # pass candidate through to @peerConnection
    @peerConnection.addIceCandidate candidate

  # internal methods
  _polyFill: ->
    # To be implemented:
    # polyfill between webkit and mozilla implementations
    # just do webkit for now
    window.RTCPeerConnection = webkitRTCPeerConnection
  
  _setupListeners: ->
    # listener for PeerConnection connections
    @peerConnection.onicecandidate  = @options.onIceCandidate if @options.onIceCandidate
    @peerConnection.ondatachannel   = @_onDataChannel

  _channelStateChanged: =>
    # the channel's state has changed
    console.log 'DataChannel state changed to: ', @dataChannel.readyState
  
  _onDataChannel: (event) =>
    @dataChannel = event.channel

    @_setupDCListeners()

  _setupDCListeners: ->
    # listeners for datachanel state changes
    @dataChannel.onopen     = @dataChannel.onclose = @_channelStateChanged    
    @dataChannel.onmessage  = @options.onMessage if @options.onMessage

  _createOffer: (callback) ->
    @peerConnection.createOffer (offer) =>
      @peerConnection.setLocalDescription offer
      callback(offer)

  _createAnswer: (callback) ->
    @peerConnection.createAnswer (answer) =>
      @peerConnection.setLocalDescription answer
      callback(answer)
