# TIME MARKER LIST    
@TimeMarkersView = Backbone.View.extend
  el: '#display'
  
  initialize: () ->
    @timeMarkers = new TimeMarkers()
    @timeMarkers.on 'add', @addTimeMarker, @
    @eventHandlers()
    
  addTimeMarker: (data) ->
    marker = new TimeMarkerView
      model: data
    data.times.on 'add', @addTime, @
    @$el.append marker.render()
    
  addTime: (data) ->
    app.events.trigger 'time_unit_placed', data.get('time')
  
  eventHandlers: () ->
    socket.registerPrivate 'time_marker', (data) =>
      @timeMarkers.add data 
      
    socket.registerPrivate 'time_marker_times', (data) =>
      tmp = new TimeMarkerTimes data
      timeMarkersList = @timeMarkers
      tmp.each (element,idx) =>
        marker = timeMarkersList.get(element.get('time_marker_id'))
        element.timeMarker = marker
        if element.get('first') != true
          element.prev=tmp.models[idx-1]
        if element.get('last') != true
          element.next=tmp.models[idx+1]  
        marker.times.add(element)
   
        if element.timeMarker.get('singleton')==true
          new TimeMarkerMapView 
            model: element
        if element.timeMarker.get('linear')==true
          new TimeMarkerLineMapView
            model: element
        if element.timeMarker.get('polygon')==true
          new TimeMarkerPolygonMapView
            model: element
        