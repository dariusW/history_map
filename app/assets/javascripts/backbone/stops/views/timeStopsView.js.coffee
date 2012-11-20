@TimeStopsView = Backbone.View.extend
  el: '#time_stop_view'
  
  initialize: () ->
    @collection = new TimeStops()
    @collection.on 'add', @addItem, @
    @eventHandlers()
    
  eventHandlers: () ->
    socket.registerPrivate "time_stops_list", (data) =>
      @collection.add data
    
  addItem: (data) ->
    item = new TimeStopItemView
      model: data
      story: app.openedStory
    item.hide()
    @$('ul').append item.render()
    app.events.trigger "time_unit_placed", (data.get('time'))
  