class KeyboardHandler
  RightArrow: false
  LeftArrow:  false
  UpArrow:    false
  DownArrow:  false
  SpaceBar:   false

  constructor: ->
    $(window).on 'keydown', @_keyDownHandler
    $(window).on 'keyup',   @_keyUpHandler  

  _keyDownHandler: (e) =>
    switch e.keyCode
      when 32 then @SpaceBar   = true
      when 39 then @RightArrow = true
      when 37 then @LeftArrow  = true
      when 38 then @UpArrow    = true
      when 40 then @DownArrow  = true

  _keyUpHandler: (e) =>
    switch e.keyCode
      when 32 then @SpaceBar   = false
      when 39 then @RightArrow = false
      when 37 then @LeftArrow  = false
      when 38 then @UpArrow    = false
      when 40 then @DownArrow  = false

module.exports = new KeyboardHandler()