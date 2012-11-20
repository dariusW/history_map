#MAP LINE VIEW OF LINEAR ELEMENT
@TimeMarkerLineMapView = Backbone.View.extend
  initialize: () ->
    @showTrace = false;
    @model.view = @
    @line = new google.maps.Polyline
      editable: false
      geodesic: true
      map: map.map
      strokeColor: "##{@model.timeMarker.get('color')}"
      strokeWidth: 5
      visible: false
      path: @model.latlngArray
    @model.line = @line
    @info = new TimeMarkerTimeInfoView
      model: @model 
      object: @line
    @prev = @model.prev
    @next = @model.next  
    @registerEvents()
  
    
  refresh: () ->
    @info.refresh
    
  registerEvents: () ->
    app.events.on "enable-trace", (model) =>
      
      
    app.events.on "disable-trace", (model) =>
      
    
    app.events.on "display-time-clear", () =>
      @line.setVisible(false)
      @model.timeMarker.view.hide()
      @info.infowindow.close()
    
    precision = app.openedStory.get('precision_skip')
    startDate = @model.get('time')
    endDate = startDate
    if(@model.next?)
      endDate = @model.next.get('time')
      endDate = endDate - precision
      
    app.events.trigger 'bind-with-time', startDate,endDate, () =>
      @line.setVisible(true)
      if(!(@model.get('first')==true) && @showTrace)
        ;  
      if(!(@model.get('last')==true) && @showTrace)
        ;
    
      @model.timeMarker.view.show()    
      
    app.events.on "closeStory", () =>
      @$el.hide()
      @line.setVisible(false)