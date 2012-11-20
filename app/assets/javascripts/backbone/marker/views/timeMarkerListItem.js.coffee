#TIME MARKERS LIST ITEM
@TimeMarkerView = Backbone.View.extend
  className: "time-marker" 
    
  events:
    "click h3" : "showTimeMarkerInfo"
    "click img" : "gotoTimeMarkerLatLng"
    "change input" : "toggleTrace"
    
  initialize: () ->
    @model.view = @  
    @eventssHandlers()
    
    
  toggleTrace: () ->
    if @$('input').is(':checked')
      app.events.trigger 'enable-trace', @model
    else
      app.events.trigger 'disable-trace', @model
    
  showTimeMarkerInfo: () ->
    info = new TimeMarkerInfoView
      model: @model
  
  gotoTimeMarkerLatLng: () ->
    _.each @model.times.models, (element) =>
      if(element.mapMarker.getVisible() == true)
        map.map.setCenter(element.mapMarker.getPosition())
    
    
  eventssHandlers: () ->   
    app.events.on "closeStory", () =>
      @$el.hide()
      
  render: () ->
    @$el.html app.template 'timeMarkerView','marker', @model.toJSON()
    @hide()
    @$el

  show: () ->
    @$el.show()
    
  hide: () ->
    @$el.hide()
    