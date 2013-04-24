require 'createjs'
KeyboardHandler = require '../lib/KeyboardHandler'
RealtimeManager = require '../lib/RealtimeManager'

module.exports = class Player extends createjs.Container
  baseColor: '#000'

  constructor: (@color) ->
    super
    createjs.Ticker.addListener(@)

    # setup basic vars
    @velocity  = new createjs.Point(0, 0)
    @speed     = 0
    @x = @y    = 10

    # draw the damn thing
    @_draw()

  _draw: ->

    # set size and registration points
    @height = @width  = 32
    @regX   = @regY   = 16

    # initialize spritesheet
    spritesheet = new createjs.SpriteSheet
      images: ['images/own_tank.png']
      frames: 
        width:  32
        height: 32

      animations:
        drive: [0,7, null, 4]

    # initialize sprite animation
    @animation = new createjs.BitmapAnimation spritesheet

    # start at first frame of animation
    @animation.currentFrame =0

    # add the animation to stage
    @addChild @animation

  tick: =>
    # movement
    @_move()

    # adjust animation based on movement
    @_animation()

    # only sync position if moving
    unless @velocity.x is 0 and @velocity.y is 0 and @rotation is @prev_rotation
      @_syncPosition()

  _animation: ->
    if KeyboardHandler.DownArrow or KeyboardHandler.UpArrow
      @animation.paused = false
    else
      @animation.paused = true

  _syncPosition: ->
    # broadbast position to opponent
    App.RealtimeManager.sendLocation x:@x, y:@y, r: @rotation

  _move: ->
    movement_max   = 10
    @prev_rotation = @rotation


    # steering
    if KeyboardHandler.RightArrow then @rotation+= 10
    if KeyboardHandler.LeftArrow  then @rotation-= 10

    # limit rotation at 180/-180 degrees
    if @rotation > 180
      @rotation = (0 - @rotation) + (@rotation - 180)
    else if @rotation < -180
      @rotation = 180 - (@rotation + 180)

    # foreward movement
    if KeyboardHandler.DownArrow  and @speed > 0-movement_max then @speed -= 1
    if KeyboardHandler.UpArrow    and @speed < movement_max   then @speed += 1

    # return to zero speed with ease if arrow keys are released
    unless KeyboardHandler.DownArrow or KeyboardHandler.UpArrow
      if @speed > 0 then @speed -=1
      if @speed < 0 then @speed +=1

    # TODO: Refactor this into some other class
    # so the opponent class can use this too! :D

    # do some fancy calculations
    factor = new createjs.Point(0,0)

    if @rotation >= 0 and @rotation <= 90
      factor.x = @rotation / 90
      factor.y = 1 - factor.x

    else if @rotation > 90 and @rotation <= 180
      factor.y = (@rotation - 90) / 90
      factor.x = 1 - factor.y

    else if @rotation < 0 and @rotation >= -90
      factor.x = Math.abs(@rotation) / 90
      factor.y = 1 - factor.x

    else if @rotation < -90 and @rotation >= -180
      factor.y = (Math.abs(@rotation)-90) / 90
      factor.x = 1 - factor.y

    else
      factor.y = factor.x = 0
    
    # turn factors into actual speeds
    if @rotation < 0 and @rotation >= -90
      @velocity.x = 0 - @speed * factor.x;
      @velocity.y = 0 - @speed * factor.y;
    
    else if @rotation >= 0 and @rotation <= 90
      @velocity.x = @speed * factor.x;
      @velocity.y = 0 - @speed * factor.y;
    
    else if @rotation >= 90 and @rotation <= 180
      @velocity.x = @speed * factor.x;
      @velocity.y = @speed * factor.y;
    
    else if @rotation <= -90 and @rotation >= -180
      @velocity.x = 0- @speed * factor.x;
      @velocity.y = @speed * factor.y;
    
    else
      @velocity.x = @velocity.y = 0


    # assign actual position
    @x += @velocity.x
    @y += @velocity.y









