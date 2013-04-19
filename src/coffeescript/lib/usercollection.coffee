module.exports = class UserCollection
  _users: []

  constructor: ->
    App.Socket.on 'users:list',             @_handleUserList
    App.Socket.on 'users:add',              @_handleUserAdd
    App.Socket.on 'users:remove',           @_handleUserRemove
    App.Socket.on 'users:challenge:new',    @_handleChallenge
    App.Socket.on 'users:challenge:finish', @_handleCompleteHandshake

    App.Connection.setOnChangeCallback (event) ->
      console.log 'onChangeCallback fired: ', event
      App.Connection.send "Hello, via DataChannel!"

    App.Connection.setOnDataCallback (event) ->
      console.log 'Yay! data: ', event.data

  setOnchangeHandler: (cb) ->
    @_onChangeCallback = cb

  removeUser: (user) ->
    index = 0
    while index < @_users.length
      if @_users[index].id is user.id
        @_users.splice index+1, 1
      index++

  addUser: (user) ->
    @_users.push user

  getUserById: (id) ->
    index = 0
    while index < @_users.length
      if @_users[index].id is id
        return @_users[index]
      index++    

  challangeUser: (userId) ->
    user = @getUserById userId
    App.Connection.createSession (handshake) ->
      packet = JSON.stringify('user':user, 'from': App.CurrentPlayer, 'handshake':handshake)
      App.Socket.emit 'users:challenge:new', packet

  getUsers: ->
    return @_users

  _handleUserList: (data) =>
    @_users = JSON.parse(data)
    @_onChangeCallback() if @_onChangeCallback

  _handleUserAdd: (data) =>
    @addUser JSON.parse(data)
    @_onChangeCallback() if @_onChangeCallback

  _handleUserRemove: (data) =>
    @removeUser JSON.parse(data)
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






