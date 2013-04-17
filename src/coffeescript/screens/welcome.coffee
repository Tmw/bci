Screen = require './screen'
module.exports = class Welcome extends Screen
  screen: '.welcome'

  events:
    'keydown [name=username]' : '_onKeyDown'

  onShow: ->
    # do some awesome shit
    $('[name=username]').focus()

  _onKeyDown: (e) ->
    # if return key is pressed, set username in model
    # and transition to new state

    if e.keyCode is 13
      val = $('[name=username]').val()
      if val.length > 0
        App.CurrentPlayer.set('username', val)
        App.transitionToState('playerselect')
        