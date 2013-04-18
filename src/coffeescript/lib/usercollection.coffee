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

  getUsers: ->
    return @_users

  _handleUserList: (data) =>
    @_users = JSON.parse(data)
    console.log @_users
    @_onChangeCallback() if @_onChangeCallback

  _handleUserAdd: (data) =>
    @_users.push(JSON.parse(data))
    @_onChangeCallback() if @_onChangeCallback
    console.log @_users

  _handleUserRemove: (data) =>
    @removeUser JSON.parse(data)
    console.log @_users
    @_onChangeCallback() if @_onChangeCallback