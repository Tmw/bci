Screen = require './screen'
module.exports = class PlayerSelect extends Screen
  screen: '.playerselect'
  
  onShow: ->
    @$('[name=username]').text(App.CurrentPlayer.get('username'))