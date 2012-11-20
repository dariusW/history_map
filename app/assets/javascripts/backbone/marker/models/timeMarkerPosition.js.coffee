#TIME MARKER POSITITON
@TimeMarkerPosition = Backbone.Model.extend
  initialize: () ->
    @id = @.get('id')
    if @id?
      @id=@cid
    @timeMarker = null
    @timeMarkerTime = null
    @latlng = new google.maps.LatLng(@.get('lat'), @.get('lng'))
  
  toJSON: () ->
    id: @.get('id')
    lat: @.get('lat')
    lng: @.get('lng')
    time_markers_time_id: @.get('time_markers_time_id')
    order: @.get('order')

@TimeMarkerPositions = Backbone.Collection.extend
  model: TimeMarkerPosition
  
  toJSON: () ->
    list = new Array();
    idx = 0;
    @.each (element) =>
      list[idx]=element.toJSON()
      idx+=1
    list