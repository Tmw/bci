module.exports = class ConnectionWrapper

  # optional configuration
  # TODO: I might need to switch to a TURN server for cross-machine communication
  servers:        null
  connection:     {optional: [RtpDataChannels: true]}
  handshake:      {}

  constructor: ->
     @_polyFill()

     # setup PeerConnection and open DataChannel
     @peerConnection = new RTCPeerConnection @servers, @connection

     # setup listeners
     @_setupListeners()

  createSession: (callback) ->
    # first setup a new datachannel
    @dataChannel                = @peerConnection.createDataChannel "dc", reliable: false
    @handShakeCompleteCallback  = callback

    # setup listeners for datachannel
    @_setupDCListeners()

    # pass the thingy
    @_createOffer()

  send: (msg) ->
    if @dataChannel and @dataChannel.readyState is "open"
      @dataChannel.send(msg)

  # when the handshake completes, handle the answer
  handleAnswer: (details) ->
    detailsObj = JSON.parse(details)
    @peerConnection.setRemoteDescription new RTCSessionDescription(detailsObj.handshake.sessionDescription)
    
    for candidate in detailsObj.handshake.candidates
      @peerConnection.addIceCandidate new RTCIceCandidate(candidate)

  addIceCandidate: (candidate) ->
    # pass candidate through to @peerConnection
    @peerConnection.addIceCandidate candidate

  handleOffer: (offer, callback) =>
    @handShakeCompleteCallback = callback
    offerObj = JSON.parse(offer)

    # set remote session description
    @peerConnection.setRemoteDescription new RTCSessionDescription(offerObj.handshake.sessionDescription)

    # iterate over the ICE candidates and add them
    for candidate in offerObj.handshake.candidates
      @peerConnection.addIceCandidate new RTCIceCandidate(candidate)

    # create an answer
    @_createAnswer()

  setOnDataCallback: (cb) ->
    # callback when data is received via the DataChannel
    @_dcOnDataCallback = cb

  setOnChangeCallback: (cb) ->
    # callback when datachannel state is changed
    @_dcOnChangeCallback = cb

  ####  
  # internal methods
  ####
  _polyFill: ->
    # polyfill between webkit and mozilla implementations
    window.RTCPeerConnection = webkitRTCPeerConnection || mozRTCPeerConnection
  
  _setupListeners: ->
    # listener for PeerConnection connections
    @peerConnection.onicecandidate             = @_onIceCandidate
    @peerConnection.ondatachannel              = @_onDataChannel
    @peerConnection.oniceconnectionstatechange = @_channelStateChanged

  _channelStateChanged: (event) =>
    # the channel's state has changed
    @_dcOnChangeCallback(event) if @_dcOnChangeCallback

  _channelDataReceived: (event) =>
    @_dcOnDataCallback(event) if @_dcOnDataCallback

  _onIceCandidate: (event) =>
    if event.candidate
      @handshake.candidates or= []
      @handshake.candidates.push event.candidate
    else if event.candidate is null
      @handShakeCompleteCallback(@handshake)

  _onDataChannel: (event) =>
    @dataChannel = event.channel
    @_setupDCListeners()

  _setupDCListeners: =>
    # listeners for datachanel state changes
    @dataChannel.onopen     = @dataChannel.onclose = @_channelStateChanged    
    @dataChannel.onmessage  = @_channelDataReceived

  _createOffer: ->
    @peerConnection.createOffer (offer) =>
      @handshake.sessionDescription = @_bandwidthHack(offer)
      @peerConnection.setLocalDescription offer

  _bandwidthHack: (sdp) ->
    splitted = sdp.sdp.split("b=AS:30")
    sdp.sdp = splitted[0] + "b=AS:1638400" + splitted[1]
    return sdp

  _createAnswer: ->
    @peerConnection.createAnswer (answer) =>
      @handshake.sessionDescription = @_bandwidthHack(answer)
      @peerConnection.setLocalDescription answer
