require 'createjs'
Screen  = require './screen'
KeyboardHandler = require '../lib/KeyboardHandler'

module.exports = class Game extends Screen
  screen: '.game'
  #events:

  initialize: ->
    createjs.Ticker.setFPS 60

  onShow: ->
    console.log 'ok'

    @stage   = new createjs.Stage('canvas')
    @circle  = new createjs.Shape()

    @circle.graphics.beginFill("red").drawCircle(0, 0, 40)

    @circle.x = @circle.y = 50
    @stage.addChild(@circle)
    @stage.update()
    createjs.Ticker.addListener(@)

    @velocity = new createjs.Point(0,0)

  tick: =>
    if KeyboardHandler.RightArrow
      @velocity.x +=1 if @velocity.x < 5
    else if KeyboardHandler.LeftArrow
      @velocity.x -=1 if @velocity.x > -5

    # actual moving
    @circle.x += @velocity.x
    @circle.y += @velocity.y


    @stage.update()
