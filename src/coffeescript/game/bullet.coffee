require 'createjs'
ForceHelper = require '../lib/ForceHelper'

module.exports = class Bullet extends createjs.Shape
  constructor: (@x, @y, @rotation, @stage)->
    super
    createjs.Ticker.addListener(@)
    @stage.addChild(@)
    @graphics.beginFill("#CCC").drawCircle(0, 0, 5)

    @speed = 15
    @force = ForceHelper(@rotation, @speed)

  destroy: ->
    # remove from stage and remove reference in the Ticker
    @stage.removeChild(@)
    createjs.Ticker.removeListener(@) 

  tick: ->
    # update the actual position
    @x += @force.x
    @y += @force.y

    # dump when out of bounds
    if @_outOfBounds() then @destroy()

  _outOfBounds: ->
    return @x > @stage.canvas.width or @y > @stage.canvas.height or @x < 0 or @y < 0
      