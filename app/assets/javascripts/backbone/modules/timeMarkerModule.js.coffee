TimeMarker = Backbone.Model.extend

  initialize: (model) ->
    @times = new TimeMarkerTimes()
    @id = @.get('id')
    if(@.get('color')==null)
      @.set('color', 'FE7569')
    @.set('base_marker_api', map.defaults.marker_color)
    @markerColor = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + @.get('color'),new google.maps.Size(21, 34),new google.maps.Point(0,0),new google.maps.Point(10, 34))
    @markerShadow = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow", new google.maps.Size(40, 37), new google.maps.Point(0, 0), new google.maps.Point(12, 35));
  
  toJSON: () ->
    content: @.get('content')      
    full_title: @.get('full_title')
    id: @.get('id')
    story_id: @.get('story_id')
    color: @.get('color')
    base_marker_api: @.get('base_marker_api')
    
TimeMarkerTime = Backbone.Model.extend

  initialize: (model) ->
    @id = @.get('id')
    @timeMarker = null
    @mapMarker = null
    @latlng = new google.maps.LatLng(@.get('latitude'),@.get('longitude'))
    
  toJSON: () ->
    content: @.get('content')      
    latitude: @.get('latitude')
    longitude: @.get('longitude')
    id: @.get('id')
    time_marker_id: @.get('time_marker_id')
    time: @.get('time')
    last: @.get('last')
    first: @.get('first')
    full_title: @timeMarker.get('full_title')
    full_time: @.get('full_time')

TimeMarkers = Backbone.Collection.extend
  model: TimeMarker
  
TimeMarkerTimes = Backbone.Collection.extend
  model: TimeMarkerTime
  
TimeMarkerMapView = Backbone.View.extend
  initialize: () ->
    @showTrace = true
    @model.view = @
    @marker = new google.maps.Marker
      draggable: false
      position: @model.latlng
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
    @prev = @model.prev
    @next = @model.next
    @registerEvents()
    
  refresh: () ->
    @info.refresh
    
  registerEvents: () ->
    
    app.events.on "enable-trace", () =>
      @showTrace = true
      
    app.events.on "disable-trace", () =>
      @showTrace = false
    
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
        ltlgArray = [@model.latlng, @model.prev.latlng]
        @pastTrace.setPath ltlgArray
        @pastTrace.setVisible true
      if(!(@model.get('last')==true) && @showTrace)
        ltlgArray = [@model.latlng, @model.next.latlng]
        @futureTrace.setPath ltlgArray
        @futureTrace.setVisible true
      
      
      @model.timeMarker.view.show()    
      
    app.events.on "closeStory", () =>
      @$el.hide()
      @marker.setVisible(false)
  
TimeMarkerTimeInfoView = Backbone.View.extend
  className: "tooltip"
    
  initialize: () ->
    @model.view_info = @
    @render()

  render: () ->
    temp = app.template 'timeMarkerTimeInfoView', @model.toJSON()
    @infowindow = new google.maps.InfoWindow
      content: temp
    google.maps.event.addListener @model.mapMarker, 'click', () =>
      @infowindow.setContent(app.template 'timeMarkerTimeInfoView', @model.toJSON())
      @infowindow.open(map.map,@model.mapMarker)

TimeMarkerInfoView = Backbone.View.extend
  className: 'modal'
  
  events:
    "click #ok":"ok"
    
  initialize: () ->
    @model.view_info = @
    @render()
    
  render: () ->
    temp = app.template 'markerMoreInfo', @model.toJSON()
    @$el.html(temp)
    @$el.modal
      backdrop: true
    
  
  ok: (evt) ->
     @$el.modal 'hide'
     evt.preventDefault()

  
TimeMarkerView = Backbone.View.extend
  className: "time-marker" 
    
  events:
    "click h3" : "showTimeMarkerInfo"
    "click img" : "gotoTimeMarkerLatLng"
    
  initialize: () ->
    @model.view = @  
    @eventssHandlers()
    
    
  showTimeMarkerInfo: () ->
    info = new TimeMarkerInfoView
      model: @model
  
  gotoTimeMarkerLatLng: () ->
    _.each @model.times.models, (element) =>
      if(element.mapMarker.getVisible() == true)
        map.map.setCenter(element.mapMarker.getPosition())
    
    
  eventssHandlers: () ->   
    app.events.on "closeStory", () =>
      @$el.hide()
      
  render: () ->
    @$el.html app.template 'timeMarkerView', @model.toJSON()
    @hide()
    @$el

  show: () ->
    @$el.show()
    
  hide: () ->
    @$el.hide()
    
    
TimeMarkersView = Backbone.View.extend
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
      _.each tmp.models, (element,idx) ->
        marker = timeMarkersList.get(element.get('time_marker_id'))
        element.timeMarker = marker
        if element.get('first') != true
          element.prev=tmp.models[idx-1]
        if element.get('last') != true
          element.next=tmp.models[idx+1]  
        marker.times.add(element)
        new TimeMarkerMapView 
          model: element
        
  
  

class TimeMarkerModule
  constructor: () ->
    @timeMarkersView = new TimeMarkersView()
  
$ ->
  timeMarkerModule = new TimeMarkerModule()
  
   