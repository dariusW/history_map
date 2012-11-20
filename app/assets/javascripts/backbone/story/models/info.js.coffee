@InfoModel = Backbone.Model.extend
  initialize: () ->
    @position = new google.maps.LatLng(@.get('lat'),@.get('long'))
  
  toJSON: () ->
    content: @.get('content')
    full_title: @.get('full_title')
    lat: @.get('lat')
    long: @.get('long')
    date: @.get('date')
    
@InfoModels = Backbone.Collection.extend
  model: InfoModel
