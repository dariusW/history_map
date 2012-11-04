class MapModule
  defaults:
    key: 'AIzaSyCaZbAvvE0z0Go_SOeivdAxwakkrXC8GVU'
    id: 'map_canvas'
    marker_color: 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|'
    marker_shadow: 'http://chart.apis.google.com/chart?chst=d_map_pin_shadow'
    
    
  mapDefaults:
    disableDefaultUI : true
    center : new google.maps.LatLng(-34.397, 150.644)
    zoom : 8
    mapTypeId : google.maps.MapTypeId.TERRAIN,   
    
  constructor: () ->
    @canvas = document.getElementById(@defaults.id)
    $('#pageContainer').height($(window).height() - 40 - 40);
    $(window).resize ->
      $('#pageContainer').height($(@).height() - 40 - 40);
     
    @map = new google.maps.Map(@canvas, @mapDefaults)
    
    
$ => 
  @map = new MapModule
  
    
