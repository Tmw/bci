require 'jQuery'
ConnectionWrapper   = require './lib/ConnectionWrapper'
WelcomeScreen       = require './screens/welcome'
PlayerSelectScreen  = require './screens/playerselect'

class _app
  currentScreen:  null
  usercollection: []
  currentState:   'welcome'

  constructor: ->
    @showScreen new WelcomeScreen()

  showScreen: (screen) ->
    # close previous view, if available
    @currentScreen.close() if @currentScreen isnt null

    @currentScreen = screen
    @currentScreen.show()

  stateChanged: ->
    switch @currentState
      when "welcome"
        @showScreen new WelcomeScreen()
      when "playerselect"
        @showScreen new PlayerSelectScreen()

  setState: (state) ->
    if state isnt @currentState
      @currentState = state
      @stateChanged()
    
    # setup the dom listeners
    #@_setupDomListeners()

    #@socket = new io.connect()
    #@socket.emit 'ready', username: $('[name=username]').val()

    #@socket.on 'data', (data) -> 
    #  console.log data.sydney

    #connection = new ConnectionWrapper()




# initialize the app when the dom is ready
$ ->
  window.app = new _app()