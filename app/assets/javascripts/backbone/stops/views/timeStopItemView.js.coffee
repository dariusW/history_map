@TimeStopItemView = Backbone.View.extend
  className: "time_stop_item"
  tagName: "li"
  
  events: 
    "click a": "moreInfo"
    
  moreInfo: () ->
    map.map.setCenter(@model.latlng)
    new TimeStopView
      model: @model
  
  initialize: () ->
    @model.view = @
    @eventHandlers()
    
  eventHandlers: () ->
    app.events.on "display-time-clear", () =>
      @hide()
    
    startDate = @model.get('time')
    endDate = @model.get('time')
    
    app.events.trigger 'bind-with-time', startDate,endDate, () =>
      @show()
    
    app.events.on "closeStory", () =>
      @hide()
      
  hide: () ->
    @$el.hide()
    
  show: () ->
    @$el.show()
    
  render: () ->
    @$el.html app.template 'timeStopItem','stops', @model.toJSON()
    @$el
    