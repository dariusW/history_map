@WikiInfo = Backbone.View.extend
  
  initialize: () ->
    @eventHandlers()
    @position = new google.maps.LatLng(@model.get('lat'), @model.get('lng'))
    @infowindow = new google.maps.InfoWindow
    @marker = new google.maps.Marker
      position: @position
      map: map.map
      
    
  eventHandlers: () ->
 
    
    

  render: () ->
    c = app.template 'wiki','wikipedia', @model.toJSON()
    @infowindow.setContent(c)
    
    @infowindow.open(map.map,@marker)
