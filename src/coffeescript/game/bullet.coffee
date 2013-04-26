require 'createjs'
ForceHelper     = require '../lib/ForceHelper'

module.exports = class Bullet extends createjs.Shape

  constructor: (@x, @y, @stage, @owned=true) ->
    super
    
    # setup color based on the owner
    color = if @owned then "#CCC" else "#FC0"
    @graphics.beginFill(color).drawCircle(0, 0, 5)

    # setup basic vars and calculate force
    @speed = 15

  destroy: ->
    # remove from stage and remove reference in the Ticker
    @stage.removeChild(@)
    createjs.Ticker.removeListener(@)

  fromRotation: (rotation) ->
    @force = ForceHelper(rotation, @speed)
    @_start()
    return @

  withForce: (force) ->
    @force = force
    @_start() 
    return @

  tick: ->
    if @force
      # update the actual position
      @x += @force.x
      @y += @force.y

    # dump when out of bounds
    if @_outOfBounds() then @destroy()

  _outOfBounds: ->
    return @x > @stage.canvas.width or @y > @stage.canvas.height or @x < 0 or @y < 0

  _start: ->
    @_syncBullet() if @owned
    createjs.Ticker.addListener(@)
    @stage.addChild(@)

  _syncBullet: ->
    App.RealtimeManager.sync "opponent:bullet", {x:@x, y:@y, force: @force}