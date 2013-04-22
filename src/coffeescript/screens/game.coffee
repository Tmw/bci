require 'createjs'
Screen  = require './screen'
module.exports = class Game extends Screen
  screen: '.game'
  #events:

  initialize: ->


  onShow: ->
    console.log 'ok'

    @stage   = new createjs.Stage('canvas')
    @circle  = new createjs.Shape()

    @circle.graphics.beginFill("red").drawCircle(0, 0, 40)

    @circle.x = @circle.y = 50
    @stage.addChild(@circle)
    @stage.update()

    createjs.Ticker.addListener(@)

  tick: =>
    @circle.x += 1
    @stage.update()

