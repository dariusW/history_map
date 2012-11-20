#MAP POLYGON VIEW OF POLYGON ELEMENT
@TimeMarkerPolygonMapView = Backbone.View.extend
  initialize: () ->
    @showTrace = false;
    @model.view = @
    @polygon = new google.maps.Polygon
      editable: false
      geodesic: true
      map: map.map
      strokeColor: "##{@model.timeMarker.get('color')}"
      fillColor: "##{@model.timeMarker.get('color')}"
      strokeWidth: 5
      visible: false
      path: @model.latlngArray
    @model.polygon = @polygon
    @info = new TimeMarkerTimeInfoView
      model: @model 
      object: @polygon
    @prev = @model.prev
    @next = @model.next  
    @registerEvents()
  
    
  refresh: () ->
    @info.refresh
    
  registerEvents: () ->
    app.events.on "enable-trace", (model) =>
      
      
    app.events.on "disable-trace", (model) =>
      
    
    app.events.on "display-time-clear", () =>
      @polygon.setVisible(false)
      @model.timeMarker.view.hide()
      @info.infowindow.close()
    
    precision = app.openedStory.get('precision_skip')
    startDate = @model.get('time')
    endDate = startDate
    if(@model.next?)
      endDate = @model.next.get('time')
      endDate = endDate - precision
      
    app.events.trigger 'bind-with-time', startDate,endDate, () =>
      @polygon.setVisible(true)
      if(!(@model.get('first')==true) && @showTrace)
        alert("enavle")
      if(!(@model.get('last')==true) && @showTrace)
        alert('disable')
    
      @model.timeMarker.view.show()    
      
    app.events.on "closeStory", () =>
      @$el.hide()
      @polygon.setVisible(false)
      