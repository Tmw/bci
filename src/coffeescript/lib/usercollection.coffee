module.exports = class UserCollection
  _users: []

  constructor: ->
    App.Socket.on 'users:list',   @_handleUserList
    App.Socket.on 'users:add',    @_handleUserAdd
    App.Socket.on 'users:remove', @_handleUserRemove

  setOnchangeHandler: (cb) ->
    @_onChangeCallback = cb

  removeUser: (user) ->
    index = 0
    while index < @_users.length
      if @_users[index].id = user.id
        @_users.splice index, 1
      index++

  addUser: (user) ->
    @_users.push user

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