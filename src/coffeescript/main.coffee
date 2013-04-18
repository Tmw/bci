require 'jQuery'
ConnectionWrapper   = require './lib/connectionwrapper'
UserCollection      = require './lib/usercollection'
UserModel           = require './models/user'
WelcomeScreen       = require './screens/welcome'
PlayerSelectScreen  = require './screens/playerselect'

class _app
  Connection:     null
  currentState:   'welcome'
  CurrentPlayer:  new UserModel()

  constructor: ->
    
  start: ->
    @showScreen new WelcomeScreen()
    @Socket         = new io.connect()
    @UserCollection = new UserCollection()
    #@connection = new ConnectionWrapper()

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

  transitionToState: (state, date=null) ->
    if state isnt @currentState
      @currentState = state
      @stateChanged()

# initialize the app when the dom is ready
$ ->
  window.App = new _app()
  App.start()