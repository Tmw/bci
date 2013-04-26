require 'createjs'
KeyboardHandler = require '../lib/KeyboardHandler'
RealtimeManager = require '../lib/RealtimeManager'
ForceHelper     = require '../lib/ForceHelper'

module.exports = class Player extends createjs.Container
  baseColor: '#000'

  constructor: (@color) ->
    super
    createjs.Ticker.addListener(@)

    # setup basic vars
    @force     = new createjs.Point(0,0)
    @speed     = 0

  start: ->
    # draw the damn thing
    @_draw()

  _draw: ->
    # random spawn point within playing field
    @x        = Math.floor(Math.random() * @getStage().canvas.width)
    @y        = Math.floor(Math.random() * @getStage().canvas.height)
    @rotation = Math.floor(Math.random() * 360)
    
    # first sync :)
    @_syncPosition()

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
    unless @force.x is 0 and @force.y is 0 and @rotation is @prev_rotation
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

    # calculate force in each direction
    @force = ForceHelper(@rotation, @speed)

    # assign actual position
    @x += @force.x
    @y += @force.y





