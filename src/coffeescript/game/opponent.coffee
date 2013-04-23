require 'createjs'

module.exports = class Opponent extends createjs.Shape
  baseColor: '#000'

  constructor: (@color) ->
    super

    @graphics.beginFill(@color).drawCircle(0, 0, 5)
    @x = @y = 25
    App.RealtimeManager.subscribe "opponent:moved", @_handleMovement


  _handleMovement: (data) =>
    @x = data.x
    @y = data.y