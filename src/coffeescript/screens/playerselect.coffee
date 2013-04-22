Screen = require './screen'
module.exports = class PlayerSelect extends Screen
  screen: '.playerselect'
  events:
    'click [name=players]>li' : '_userClicked'

  initialize: ->
    App.Socket.emit 'subscribe', username: App.CurrentPlayer.get('username')
    App.CurrentPlayer.set('id', App.Socket.socket.sessionid)
    App.UserCollection.setOnchangeHandler @_collectionChanged

  onShow: ->
    header = "Welcome, #{App.CurrentPlayer.get('username')}!"
    @$('[name=welcome]').text(header)

  _collectionChanged: =>
    # begin with a empty list
    list = @$('[name=players]').empty()

    # render users
    for user in App.UserCollection.all()
      list.append "<li data-userid=\"#{user.get('id')}\">#{user.get('username')}</li>"

  _userClicked: (e) ->
    userId = $(e.currentTarget).data('userid')
    App.UserCollection.challangeUser(userId)