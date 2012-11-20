
# TIME MARKER
@TimeMarker = Backbone.Model.extend

  initialize: (model) ->
    @times = new TimeMarkerTimes()
    @id = @.get('id')
    if(@.get('color')==null)
      @.set('color', 'FE7569')
    @.set('base_marker_api', map.defaults.marker_color)
    @markerColor = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + @.get('color'),new google.maps.Size(21, 34),new google.maps.Point(0,0),new google.maps.Point(10, 34))
    @markerShadow = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow", new google.maps.Size(40, 37), new google.maps.Point(0, 0), new google.maps.Point(12, 35));
  
  toJSON: () ->
    singleton: @.get('singleton')
    polygon: @.get('polygon')
    linear: @.get('linear')
    content: @.get('content')      
    full_title: @.get('full_title')
    id: @.get('id')
    story_id: @.get('story_id')
    color: @.get('color')
    base_marker_api: @.get('base_marker_api')


@TimeMarkers = Backbone.Collection.extend
  model: TimeMarker
  