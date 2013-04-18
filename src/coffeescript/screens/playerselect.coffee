Screen = require './screen'
module.exports = class PlayerSelect extends Screen
  screen: '.playerselect'

  initialize: ->
    App.Socket.emit 'subscribe', username: App.CurrentPlayer.get('username')
    App.UserCollection.setOnchangeHandler @_collectionChanged

  onShow: ->
    @$('[name=username]').text(App.CurrentPlayer.get('username'))

  _collectionChanged: =>
    console.log 'collection changed'
    @$('[name=playah]').empty()

    users = App.UserCollection.getUsers()
    for user in users
      @$('[name=playah]').append user.username
