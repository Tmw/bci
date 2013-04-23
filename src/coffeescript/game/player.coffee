require 'createjs'
KeyboardHandler = require '../lib/KeyboardHandler'

module.exports = class Player extends createjs.Shape
  baseColor: '#000'

  constructor: (@color) ->
    super

    @graphics.beginFill("#FF0000").drawCircle(0, 0, 5)
    createjs.Ticker.addListener(@)

    @velocity = new createjs.Point(0,0)
    @x = @y = 10

  tick: =>
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

    #actual moving
    @x += @velocity.x
    @y += @velocity.y