require 'createjs'
KeyboardHandler = require '../lib/KeyboardHandler'

module.exports = class Player extends createjs.Shape
  baseColor: '#000'

  constructor: (@color) ->
    super
    @graphics.beginFill("#ffcc00").drawCircle(0, 0, 5)
    createjs.Ticker.addListener(@)

    @velocity = new createjs.Point(0,0)
    @x = @y = 10

  tick: =>
    # if KeyboardHandler.RightArrow and @velocity.x < 5 and @velocity.x >= 0
    #   @velocity.x +=1
    # else if not KeyboardHandler.RightArrow and @velocity.x >= 0 and @velocity.x < 5
    #   @velocity.x -=1


    # if KeyboardHandler.LeftArrow and @velocity > -5 and @velocity.x < 0
    #   @velocity.x -=1
    # else if not KeyboardHandler.LeftArrow and @velocity.x < 0 and @velocity.x > -5
    #   @velocity.x +=1

    console.log @velocity.x


    #actual moving
    @x += @velocity.x
    @y += @velocity.y
