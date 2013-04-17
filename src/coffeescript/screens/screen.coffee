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

  # shamelessly stolen from Backbone
  _bindEvents: ->
    if @events
      for key in Object.keys(@events)
        [event, context] = key.split ' '
        $(context).on event, @[@events[key]]

  # also stolen from Backbone :D
  $: (selector)->
    window.jQuery(@screen).find(selector)