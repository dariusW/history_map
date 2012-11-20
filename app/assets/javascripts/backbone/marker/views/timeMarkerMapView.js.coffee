#MAP VIEW OF SINGLETON 
@TimeMarkerMapView = Backbone.View.extend
  initialize: () ->
    @showTrace = false
    @model.view = @
    @marker = new google.maps.Marker
      draggable: false
      position: @model.position.latlng
      icon: @model.timeMarker.markerColor
      shadow: @model.timeMarker.markerShadow
      visible: false
      map: map.map
    @pastTrace = new google.maps.Polyline
      editable: false
      map: map.map
      strokeColor: "#FFFF99"
      visible: false
    @futureTrace =  new google.maps.Polyline
      editable: false
      map: map.map
      strokeColor: "#FFFF33"
      visible: false    
      icons: [
        icon: 
          path: google.maps.SymbolPath.FORWARD_OPEN_ARROW
          strokeColor: "#FFFF33"
          strokeOpacity: 1
        offset: '100%'
        ]
    @model.mapMarker = @marker
    @info = new TimeMarkerTimeInfoView
      model: @model
      object: @marker
    @prev = @model.prev
    @next = @model.next
    @registerEvents()
    
  refresh: () ->
    @info.refresh
    
  registerEvents: () ->
    
    app.events.on "enable-trace", (model) =>
      if model.id == @model.timeMarker.id
        @showTrace = true
        if @marker.getVisible()
          @pastTrace.setVisible true
          @futureTrace.setVisible true
          if(!(@model.get('first')==true) && @showTrace)
            ltlgArray = [@model.position.latlng, @model.prev.position.latlng]
            @pastTrace.setPath ltlgArray
            @pastTrace.setVisible true
          if(!(@model.get('last')==true) && @showTrace)
            ltlgArray = [@model.position.latlng, @model.next.position.latlng]
            @futureTrace.setPath ltlgArray
            @futureTrace.setVisible true
      
    app.events.on "disable-trace", (model) =>
      if model.id == @model.timeMarker.id
        @showTrace = false
        if @marker.getVisible()
          @pastTrace.setVisible false
          @futureTrace.setVisible false 
        
    
    app.events.on "display-time-clear", () =>
      @marker.setVisible(false)
      @model.timeMarker.view.hide()
      @futureTrace.setVisible false
      @pastTrace.setVisible false
      @info.infowindow.close()
    
    precision = app.openedStory.get('precision_skip')
    startDate = @model.get('time')
    endDate = startDate
    if(@model.next?)
      endDate = @model.next.get('time')
      endDate = endDate - precision
      
    app.events.trigger 'bind-with-time', startDate,endDate, () =>
      @marker.setVisible(true)
      if(!(@model.get('first')==true) && @showTrace)
        ltlgArray = [@model.position.latlng, @model.prev.position.latlng]
        @pastTrace.setPath ltlgArray
        @pastTrace.setVisible true
      if(!(@model.get('last')==true) && @showTrace)
        ltlgArray = [@model.position.latlng, @model.next.position.latlng]
        @futureTrace.setPath ltlgArray
        @futureTrace.setVisible true
      
      
      @model.timeMarker.view.show()    
      
    app.events.on "closeStory", () =>
      @$el.hide()
      @marker.setVisible(false)