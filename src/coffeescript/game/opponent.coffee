require 'createjs'

module.exports = class Opponent extends createjs.Container
  baseColor: '#000'

  constructor: (@color) ->
    super
    App.RealtimeManager.subscribe "opponent:moved", @_handleMovement
    @_draw()

  _draw: ->
    # set size and registration points
    @height = @width  = 32
    @regX   = @regY   = 16

    # initialize spritesheet
    spritesheet = new createjs.SpriteSheet
      images: ['images/opponent_tank.png']
      frames: 
        width:  32
        height: 32

      animations:
        drive: [0,7, null, 4]

    # initialize spritesheet animation
    @animation = new createjs.BitmapAnimation spritesheet
    @animation.currentFrame =0

    # place animation on stage
    @addChild @animation

  _handleMovement: (data) =>
    # manual animation like a boss
    @animation.currentFrame = 0 if @animation.currentFrame is 8
    @animation.currentFrame++

    # set the data received via RTC
    @rotation = data.r
    @x        = data.x
    @y        = data.y