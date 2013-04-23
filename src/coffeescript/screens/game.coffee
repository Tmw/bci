require 'createjs'
Screen          = require './screen'
KeyboardHandler = require '../lib/KeyboardHandler'
Player          = require '../game/player'

module.exports = class Game extends Screen
  screen: '.game'

  initialize: ->
    createjs.Ticker.setFPS 60
    createjs.Ticker.addListener(@)

    @stage   = new createjs.Stage('canvas')

  onShow: ->
    @playerX = new Player('#ff0000')

    @stage.addChild(@playerX)
    @stage.update()
    

  tick: =>
    @stage.update()
