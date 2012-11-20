@TimeStop = Backbone.Model.extend

  initialize: () ->
   @id = @.get('time')
   @latlng = new google.maps.LatLng(@.get('lat'), @.get('long'))
   
  toJSON: () ->
    full_title: @.get('full_title')
    content: @.get('content')
    id: @.get('id')
    lat: @.get('lat')
    long: @.get('long')
    story_id: @.get('story_id')
    time: @.get('time')
    
@TimeStops = Backbone.Collection.extend
  model: TimeStop
  