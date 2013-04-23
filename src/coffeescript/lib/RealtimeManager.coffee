module.exports = class RealtimeMananger

  constructor: ->
    @conn = App.Connection
    @conn.setOnDataCallback @_onDataHandler
    @subscribers = {}

  sendLocation: (coordinates) ->
    @conn.send @_pack "opponent:moved", coordinates

  subscribe: (event, callback) ->
    @subscribers[event] = callback

  unsubscribe: (event) ->
    delete @subscribers[event]

  _pack: (event, data) ->
    return JSON.stringify({type: event, data:data})

  _onDataHandler: (details) =>
    obj = JSON.parse details.data
    if @subscribers[obj.type]
      @subscribers[obj.type](obj.data)