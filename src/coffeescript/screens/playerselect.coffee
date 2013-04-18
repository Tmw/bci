Screen = require './screen'
module.exports = class PlayerSelect extends Screen
  screen: '.playerselect'
  events:
    'click [name=players]>li' : '_userClicked'

  initialize: ->
    App.Socket.emit 'subscribe', username: App.CurrentPlayer.get('username')
    App.UserCollection.setOnchangeHandler @_collectionChanged

  onShow: ->
    header = "Welcome, #{App.CurrentPlayer.get('username')}!"
    @$('[name=welcome]').text(header)

  _collectionChanged: =>
    # begin with a empty list
    list = @$('[name=players]').empty()

    users = App.UserCollection.getUsers()
    for user in users
      list.append "<li data-userid=\"#{user.id}\">#{user.username}</li>"

  _userClicked: (e) ->
    userId = $(e.currentTarget).data('userid')
    App.UserCollection.challangeUser(userId)