require 'createjs'

module.exports = class Opponent extends createjs.Container
  baseColor: '#000'

  constructor: (@color) ->
    super
    App.RealtimeManager.subscribe "opponent:moved", @_handleMovement
    @_draw()

  _draw: ->
    spritesheet = new createjs.SpriteSheet
      images: ['images/opponent_tank.png']
      frames: 
        width:  32
        height: 32

      animations:
        drive: [0,7, null, 4]

    @animation = new createjs.BitmapAnimation spritesheet
    @animation.currentFrame =0

    @addChild @animation

    @velocity = new createjs.Point(0,0)
    @x = @y   = 10

  _handleMovement: (data) =>
    @animation.currentFrame = 0 if @animation.currentFrame is 8
    @animation.currentFrame++

    @rotation = data.r
    @x        = data.x
    @y        = data.y