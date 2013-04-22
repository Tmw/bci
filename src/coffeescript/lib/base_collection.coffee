module.exports = class BaseCollection
  _items: []

  add: (item) ->
    @_items.push item

  remove: (item) ->
    index = 0
    while index < @length()
      if @getItemAtIndex(index).get('id') is item.get('id')
        @removeItemAtIndex(index)
      index++


  removeItemAtIndex: (index) ->
    @_items.splice index, 1

  getItemAtIndex: (index) ->
    return @_items[index]

  find: (id) ->
    index = 0
    while index < @length()
      item = @getItemAtIndex(index)
      return item if item.get('id') is id
      index++
  
  allExcept: (which) ->
    out = []
    for item in @_items
      unless item.get('id') is which.get('id')
        out.push item

    return out

  # shorthand methods
  all:               -> @_items
  length:            -> @_items.length
  reset: (contents)  -> @_items = contents
  removeWithId: (id) -> @remove(@find(id))