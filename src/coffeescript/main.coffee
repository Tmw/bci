require 'jQuery'
ConnectionWrapper   = require './lib/connectionwrapper'
UserCollection      = require './lib/usercollection'
UserModel           = require './models/user'
WelcomeScreen       = require './screens/welcome'
PlayerSelectScreen  = require './screens/playerselect'
GameScreen          = require './screens/game'

class _app
  Connection:     null
  currentState:   'welcome'
  CurrentPlayer:  new UserModel()

  constructor: ->
    
  start: ->
    @Socket         = new io.connect()
    @Connection     = new ConnectionWrapper()
    @UserCollection = new UserCollection()
    

    @showScreen new WelcomeScreen()
    

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