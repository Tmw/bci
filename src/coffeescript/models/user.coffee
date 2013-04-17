module.exports = class User
  attributes: {}

  set: (key, value) ->
    @attributes[key] = value

  get: (key) ->
    return @attributes[key]
