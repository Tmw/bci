module.exports = class BaseCollection
  _items: []

  add: (item) ->
    @_items.push item

  remove: (item) ->
    index = 0
    while index < @length()
      if @getItemAtIndex(index).id is item.id
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
      return item if item.id is id
      index++
  
  
  # shorthand methods
  all:              -> @_items
  length:           -> @_items.length
  reset: (contents) -> @_items = contents