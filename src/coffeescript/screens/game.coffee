require 'createjs'
Screen          = require './screen'
KeyboardHandler = require '../lib/KeyboardHandler'
Player          = require '../game/player'
Opponent        = require '../game/opponent'

module.exports = class Game extends Screen
  screen: '.game'

  initialize: ->
    createjs.Ticker.setFPS 60
    createjs.Ticker.addListener(@)

    @stage    = new createjs.Stage('canvas')

  onShow: ->
    @you      = new Player('#FF0000')
    @opponent = new Opponent('#0000FF')

    @stage.addChild(@you)
    @stage.addChild(@opponent)

  tick: =>
    @stage.update()