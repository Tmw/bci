BaseCollection = require './base_collection'
UserModel      = require '../models/user'

module.exports = class UserCollection extends BaseCollection

  constructor: ->
    App.Socket.on 'users:list',             @_handleUserList
    App.Socket.on 'users:add',              @_handleUserAdd
    App.Socket.on 'users:remove',           @_handleUserRemove
    App.Socket.on 'users:challenge:new',    @_handleChallenge
    App.Socket.on 'users:challenge:finish', @_handleCompleteHandshake

    # this needs to go in the main.coffe
    App.Connection.setOnChangeCallback (event) ->
      console.log 'onChangeCallback fired: ', event
      App.Connection.send "Hello, via DataChannel!"

    # this is only really important in the game screen
    App.Connection.setOnDataCallback (event) ->
      console.log 'Yay! data: ', event.data

  setOnchangeHandler: (cb) ->
    @_onChangeCallback = cb

  challangeUser: (userId) ->
    user = @find userId
    App.Connection.createSession (handshake) ->
      packet = JSON.stringify('user':user, 'from': App.CurrentPlayer, 'handshake':handshake)
      App.Socket.emit 'users:challenge:new', packet

  _toModels: (data) ->
    out = []
    for item in data
      out.push new UserModel itm

    return out

  _handleUserList: (data) =>
    @reset @_toModels JSON.parse(data)
    @_onChangeCallback() if @_onChangeCallback

  _handleUserAdd: (data) =>
    @add new UserModel(data)
    @_onChangeCallback() if @_onChangeCallback

  _handleUserRemove: (data) =>
    @removeWithId JSON.parse(data).id
    @_onChangeCallback() if @_onChangeCallback

  _handleChallenge: (data) =>
    dataobj = JSON.parse data
    c = confirm "#{dataobj.from.username} would like to challenge you. Accept?"
    if c
      App.Connection.handleOffer data, (handshake) ->
        packet = JSON.stringify('user':dataobj.from, 'from': App.CurrentPlayer, 'handshake':handshake)
        App.Socket.emit 'users:challenge:finish', packet
    else
      # we should probably inform the other player of its rejection.. :)

  _handleCompleteHandshake: (answer) =>
    # to complete the handshake
    App.Connection.handleAnswer(answer)






