Screen = require './screen'
module.exports = class PlayerSelect extends Screen
  screen: '.playerselect'
  
  constructor: ->
    console.log 'this is the playerselect screen'
    super()