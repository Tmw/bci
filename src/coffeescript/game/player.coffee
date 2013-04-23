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

    # movement X-axis
    if KeyboardHandler.RightArrow then @velocity.x += 1
    if KeyboardHandler.LeftArrow  then @velocity.x -= 1

    # return to zero X-velocity
    unless KeyboardHandler.RightArrow or KeyboardHandler.LeftArrow
      if @velocity.x > 0 then @velocity.x -=1
      if @velocity.x < 0 then @velocity.x +=1

    #actual moving
    @x += @velocity.x
    @y += @velocity.y