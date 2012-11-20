  
@TimeMarkerTimeInfoView = Backbone.View.extend
  className: "tooltip"
      
  initialize: () ->
    @model.view_info = @
    @render()

  render: () ->
    temp = app.template 'timeMarkerTimeInfoView','marker', @model.toJSON()
    @infowindow = new google.maps.InfoWindow
      content: temp
    google.maps.event.addListener @options.object, 'click', () =>
      app.events.trigger 'stop-all', true
      @infowindow.setContent(app.template 'timeMarkerTimeInfoView', 'marker', @model.toJSON())
      @infowindow.open(map.map,@model.mapMarker)



