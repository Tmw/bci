require 'createjs'
Screen          = require './screen'
KeyboardHandler = require '../lib/KeyboardHandler'
Player          = require '../game/player'
Opponent        = require '../game/opponent'
Bullet          = require '../game/bullet'

module.exports = class Game extends Screen
  screen: '.game'

  initialize: ->
    # disconnect from socket to pull me off of the players list
    App.Socket.emit 'unsubscribe'

    # setup EaselJS
    createjs.Ticker.setFPS 60
    createjs.Ticker.addListener(@)

    # initialize a stage
    @stage    = new createjs.Stage('canvas')

  onShow: ->
    # create players
    @you      = new Player('#FF0000')
    @opponent = new Opponent('#0000FF')

    # add players to stage
    @stage.addChild(@you)
    @stage.addChild(@opponent)

    # begin game logic for player
    @you.start()

  # each tick, update the stage
  tick: => 
    if KeyboardHandler.SpaceBar
      new Bullet(@you.x, @you.y, @you.rotation, @stage)

    @stage.update()