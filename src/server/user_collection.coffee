BaseCollection = require '../javascript/lib/base_collection'
UserModel      = require '../javascript/models/user'

module.exports = class UserCollection extends BaseCollection

  setupListeners: (@app) ->
    # if a new user subscribes
    @app.io.route 'subscribe', @_onSubscribe

  _onSubscribe: (req) =>
    # join the 'users' channel
    req.io.join 'users'

    # turn data into model object
    user = new UserModel
      id:       req.socket.id
      username: req.data.username
      socket:   req.socket

    # let other know we are in tha house
    req.io.room('users').broadcast('users:add', JSON.stringify(user))

    # save internal reference
    @add(user)

    # send back a list of already present users
    req.io.emit 'users:list', JSON.stringify(@allExcept(user))

    # setup additional listeners
    req.socket.on 'users:challenge:new',    @_handleNewChallange
    req.socket.on 'users:challenge:finish', @_handleHandshakeComplete
    req.socket.on 'disconnect',          => @_handleDisconnect(req)

  _handleDisconnect: (req) =>
    # remove user from collection
    user = @find(req.socket.id)
    @remove(user)

    # leave room
    req.io.leave('users')

    # inform others the user has left
    req.io.room('users').broadcast('users:remove', JSON.stringify(user))

  _handleNewChallange: (data) =>
    dataobj = JSON.parse data
    user    = @find(dataobj.user.id)
    socket  = user.get('socket')
    packet  = JSON.stringify('user':user, 'from':dataobj.from, 'handshake':dataobj.handshake)
    socket.emit 'users:challenge:new', packet

    # handshake complete
  _handleHandshakeComplete: (data) =>
      dataobj = JSON.parse data
      user    = @find(dataobj.user.id)
      socket  = user.get('socket')
      packet  = JSON.stringify('user':user, 'handshake':dataobj.handshake)
      socket.emit 'users:challenge:finish', packet




