require 'createjs'
KeyboardHandler = require '../lib/KeyboardHandler'
RealtimeManager = require '../lib/RealtimeManager'

module.exports = class Player extends createjs.Container
  baseColor: '#000'

  constructor: (@color) ->
    super
    createjs.Ticker.addListener(@)
    @_draw()

  _draw: ->
    spritesheet = new createjs.SpriteSheet
      images: ['images/tanks.png']
      frames: 
        width:  32
        height: 32

      animations:
        drive: [0,7, null, 4]

    @animation = new createjs.BitmapAnimation spritesheet
    @animation.currentFrame =0

    @addChild @animation

    @velocity = new createjs.Point(0,0)
    @x = @y = 10

  tick: =>
    # movement
    @_move()

    # adjust animation based on movement
    @_animation()

    # only sync position if moving
    unless @velocity.x is 0 and @velocity.y is 0
      @_syncPosition()

  _animation: ->
    if KeyboardHandler.DownArrow or KeyboardHandler.UpArrow
      @animation.paused = false
    else
      @animation.paused = true

  _syncPosition: ->
    # broadbast position to opponent
    App.RealtimeManager.sendLocation x:@x, y:@y

  _move: ->
    movement_max = 10

    # movement X-axis
    if KeyboardHandler.RightArrow and @velocity.x < movement_max   then @velocity.x += 1
    if KeyboardHandler.LeftArrow  and @velocity.x > 0-movement_max then @velocity.x -= 1

    # movement Y-axis
    if KeyboardHandler.UpArrow    and @velocity.y > 0-movement_max   then @velocity.y -= 1
    if KeyboardHandler.DownArrow  and @velocity.y < movement_max then @velocity.y += 1

    # return to zero X-velocity
    unless KeyboardHandler.RightArrow or KeyboardHandler.LeftArrow
      if @velocity.x > 0 then @velocity.x -=1
      if @velocity.x < 0 then @velocity.x +=1

    # return to zero Y-velocity
    unless KeyboardHandler.DownArrow or KeyboardHandler.UpArrow
      if @velocity.y > 0 then @velocity.y -=1
      if @velocity.y < 0 then @velocity.y +=1

    # actual moving
    @x += @velocity.x
    @y += @velocity.y
