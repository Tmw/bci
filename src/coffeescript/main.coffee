require 'jQuery'
ConnectionWrapper   = require './lib/connectionwrapper'
UserCollection      = require './lib/usercollection'
UserModel           = require './models/user'
WelcomeScreen       = require './screens/welcome'
PlayerSelectScreen  = require './screens/playerselect'
GameScreen          = require './screens/game'
RealtimeManager     = require './lib/RealtimeManager'

class _app
  Connection:     null
  currentState:   'welcome'
  CurrentPlayer:  new UserModel()

  constructor: ->
    
  start: ->
    @Socket           = new io.connect()
    @Connection       = new ConnectionWrapper()
    @UserCollection   = new UserCollection()
    @RealtimeManager  = new RealtimeManager()
    
    # When a connection is made, transition to game screen
    App.Connection.setOnChangeCallback (event) =>
      if event.type is "open"
        @transitionToState 'game'

      # when the connection is closed, transition back to playerselect screen
      else if event.type is "iceconnectionstatechange" and event.currentTarget.iceConnectionState isnt "connected"
        @transitionToState 'playerselect'

    # transition to first screen
    @stateChanged()

  showScreen: (screen) ->
    # close previous view, if available and show new screen
    @currentScreen.close() if @currentScreen isnt undefined
    @currentScreen = screen
    @currentScreen.show()

  stateChanged: ->
    switch @currentState
      when "welcome"
        @showScreen new WelcomeScreen()

      when "playerselect"
        @showScreen new PlayerSelectScreen()

      when "game"
        @showScreen new GameScreen()

  transitionToState: (state) ->
    if state isnt @currentState
      @currentState = state
      @stateChanged()

# initialize the app when the dom is ready
$ ->
  window.App = new _app()
  App.start()