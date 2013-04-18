module.exports = class UserCollection
  _users: []

  constructor: ->
    App.Socket.on 'users:list',           @_handleUserList
    App.Socket.on 'users:add',            @_handleUserAdd
    App.Socket.on 'users:remove',         @_handleUserRemove
    App.Socket.on 'users:challange:new',  @_handleChallenge

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
    App.Socket.emit 'users:challenge:new', JSON.stringify(user)

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
    user = JSON.parse data
    c = confirm "#{user.username} would like to challenge you. Accept?"






