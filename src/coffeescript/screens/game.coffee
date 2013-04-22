Screen  = require './screen'
Easel   = require 'createjs'
module.exports = class Game extends Screen
  screen: '.game'
  #events:

  initialize: ->
    console.log  Easel

  onShow: ->
    console.log 'lekkah'
    # header = "Welcome, #{App.CurrentPlayer.get('username')}!"
    # @$('[name=welcome]').text(header)