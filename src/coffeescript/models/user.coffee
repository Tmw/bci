module.exports = class User
  _attributes: {}

  constructor: (json) ->
    if json
      if typeof json is "string"
        @_attributes = JSON.parse(json)
      else if typeof json is "object"
        console.log json
        @_attributes = json

      console.log 'model created: ', @

  set: (key, value) ->
    @_attributes[key] = value

  get: (key) ->
    return @_attributes[key]

  toJSON: ->
    out  = {}
    keys = Object.keys(@_attributes)
    for key in keys
      unless typeof @_attributes[key] is "object"
        out[key] = @_attributes[key]

    return out
