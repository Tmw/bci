module.exports = class Screen

  constructor: ->
    @_bindEvents()
    @initialize() if @initialize

  show: ->
    $(@screen).removeClass 'hide'
    @onShow() if @onShow

  close: ->
    $(@screen).addClass 'hide'
    @onClose() if @onClose

  _bindEvents: ->
    for key in Object.keys(@events)
      [event, context] = key.split ' '
      $(context).on event, @[@events[key]]