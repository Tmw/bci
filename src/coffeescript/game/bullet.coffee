require 'createjs'

module.exports = class Bullet extends createjs.Shape
  constructor: (@ref, @stage)->
    super
    createjs.Ticker.addListener(@)
    @stage.addChild(@)
    @graphics.beginFill("#CCC").drawCircle(0, 0, 5)
    @direction = @ref.direction

    @factor   = @ref.direction.clone()
    @rotation = @ref.rotation

    @x = @ref.x
    @y = @ref.y

    @speed = 15
    @velocity = new createjs.Point(0,0)
    @_calculateActualMovement()

  destroy: ->
    # remove from stage and remove reference in the Ticker
    @stage.removeChild(@)
    createjs.Ticker.removeListener(@) 

  _calculateActualMovement: ->
    # turn factors into actual speeds
    if @rotation < 0 and @rotation >= -90
      @velocity.x = 0 - @speed * @factor.x;
      @velocity.y = 0 - @speed * @factor.y;
    
    else if @rotation >= 0 and @rotation <= 90
      @velocity.x = @speed * @factor.x;
      @velocity.y = 0 - @speed * @factor.y;
    
    else if @rotation >= 90 and @rotation <= 180
      @velocity.x = @speed * @factor.x;
      @velocity.y = @speed * @factor.y;
    
    else if @rotation <= -90 and @rotation >= -180
      @velocity.x = 0- @speed * @factor.x;
      @velocity.y = @speed * @factor.y;
    
    else
      @velocity.x = @velocity.y = @speed

  tick: ->
    # update the actual position
    @x += @velocity.x
    @y += @velocity.y

    # dump when out of bounds
    if @x > @stage.canvas.width or @y > @stage.canvas.height or @x < 0 or @y < 0
      @destroy()
      