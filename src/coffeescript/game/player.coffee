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
    s = $('#status')

    movement_max = 10

    # steering
    if KeyboardHandler.RightArrow then @rotation+= 10
    if KeyboardHandler.LeftArrow  then @rotation-= 10

    # limit rotation at 180/-180 degrees
    if @rotation > 180
      @rotation = (0 - @rotation) + (@rotation - 180)
    else if @rotation < -180
      @rotation = 180 - (@rotation + 180)

    # foreward movement
    if KeyboardHandler.UpArrow    and @speed > 0-movement_max then @speed += 1
    if KeyboardHandler.DownArrow  and @speed < movement_max   then @speed -= 1

    # return to zero speed with ease if arrow keys are release
    unless KeyboardHandler.DownArrow or KeyboardHandler.UpArrow
      if @speed > 0 then @speed -=1
      if @speed < 0 then @speed +=1

    # TODO: Refactor this into some other class
    # so the opponent class can use this too! :D

    # do some fancy calculations
    factorY = 0
    factorX = 0

    if @rotation >= 0 and @rotation <= 90
      factorX = @rotation / 90
      factorY = 1 - factorX

    else if @rotation > 90 and @rotation <= 180
      factorY = (@rotation - 90) / 90
      factorX = 1 - factorY

    else if @rotation < 0 and @rotation >= -90
      factorX = Math.abs(@rotation) / 90
      factorY = 1 - factorX

    else if @rotation < -90 and @rotation >= -180
      factorY = (Math.abs(@rotation)-90) / 90
      factorX = 1 - factorY

    else
      factorY = factorX = 0
    
    # turn factors into actual speeds
    if @rotation < 0 and @rotation >= -90
      @velocity.x = 0 - @speed * factorX;
      @velocity.y = 0 - @speed * factorY;
    
    else if @rotation >= 0 and @rotation <= 90
      @velocity.x = @speed * factorX;
      @velocity.y = 0 - @speed * factorY;
    
    else if @rotation >= 90 and @rotation <= 180
      @velocity.x = @speed * factorX;
      @velocity.y = @speed * factorY;
    
    else if @rotation <= -90 and @rotation >= -180
      @velocity.x = 0- @speed * factorX;
      @velocity.y = @speed * factorY;
    
    else
      @velocity.x = @velocity.y = 0


    # assign actual position
    @x += @velocity.x
    @y += @velocity.y









