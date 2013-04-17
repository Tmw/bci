Screen = require './screen'
module.exports = class Welcome extends Screen
  screen: '.welcome'

  events:
    'keydown [name=username]' : '_onKeyDown'

  onShow: ->
    # do some awesome shit
    $('[name=username]').focus()

  _onKeyDown: (e) ->
    if e.keyCode is 13
      console.log 'Username filled with '+ $('[name=username]').val()