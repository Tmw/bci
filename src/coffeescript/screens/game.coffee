require 'createjs'
Screen          = require './screen'
KeyboardHandler = require '../lib/KeyboardHandler'
Player          = require '../game/player'
Opponent        = require '../game/opponent'
Bullet          = require '../game/bullet'

module.exports = class Game extends Screen
  screen:     '.game'
  bulletList: []
  initialize: ->
    # disconnect from socket to pull me off of the players list
    App.Socket.emit 'unsubscribe'

    # setup EaselJS
    createjs.Ticker.setFPS 60
    createjs.Ticker.addListener(@)

    # initialize a stage
    @stage    = new createjs.Stage('canvas')
    App.RealtimeManager.subscribe "opponent:bullet", @_handleNewOpponentBullet

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
    # do we need to spawn a new bullet?
    if KeyboardHandler.SpaceBar
      @bulletList.push new Bullet(@you.x, @you.y, @stage).fromRotation(@you.rotation)

    # udpate stage
    @stage.update()

    # check bullet hits
    @_checkBulletHit()

  # we got some remote bullets
  _handleNewOpponentBullet: (data) =>
    @bulletList.push new Bullet(data.x, data.y, @stage, false).withForce(data.force)

  _checkBulletHit: ->
    # do some awesome shit 
    for bullet in @bulletList
      console.log  bullet.length
      if bullet and @you.hitTest(bullet.x, bullet.y)
        console.log 'hit!'
        bullet.destroy()

      # ready to be removed?
      if bullet and bullet.garbage
        index = @bulletList.indexOf(bullet)
        @bulletList.splice(index, 1)



