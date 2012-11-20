#TIME MARKER TIME    
@TimeMarkerTime = Backbone.Model.extend

  initialize: (model) ->
    @id = @.get('time')
    @timeMarker = null
    @mapMarker = null
    @position = null   
    @latlngIdx = 0
    @latlngArray = new Array()
    @positions = new TimeMarkerPositions 
    @positions.on 'add', @addLatLong, @
    if @.get('positions')?
      @positions.add @.get('positions')
 
  addLatLong: (pos) ->
    @latlngArray[@latlngIdx] = pos.latlng
    pos.latlng.marker = pos
    if(@latlngIdx==0)
      @position = @positions.at(0)  
    @latlngIdx+=1  
    
  getPositionArray: () ->
    tmp = new Array()
    idx=0
    @positions.each (pos) =>
      tmp[idx]=pos.latlng
      idx+=1
    tmp
    
    
  setPositions: (line) ->
    @latlngArray = line.getPath().b
    @positions.reset()
    for idx in [0...line.getPath().b.length] by 1
      tmp = new TimeMarkerPosition
        lat: item.lat()
        lng: item.lng()      @positions.add tmp
    # tmpPositions = new TimeMarkerPositions()
    # for idx in [0...line.getPath().b.length] by 1
      # item = line.getPath().b[idx]
# 
      # if(item.marker?)
        # obj = new TimeMarkerPosition
          # lat: item.lat()
          # lng: item.lng()
          # order: idx
          # time_markers_time_id: item.marker.get('item.marker')
        # tmpPositions.add obj
      # else
        # obj = new TimeMarkerPosition
          # lat: item.lat()
          # lng: item.lng()
          # order: idx
        # tmpPositions.add obj
#     
    # @positions.reset()
    # tmpPositions.each (elem) =>
      # @positions.add elem
#         
    
  toJSON: () ->
    content: @.get('content')      
    latitude: @.get('latitude')
    longitude: @.get('longitude')
    id: @.get('id')
    time_marker_id: @.get('time_marker_id')
    time: @.get('time')
    last: @.get('last')
    first: @.get('first')
    full_title: @timeMarker.get('full_title') if @timeMarker?
    full_time: @.get('full_time')
    position: @positions.toJSON()

@TimeMarkerTimes = Backbone.Collection.extend
  model: TimeMarkerTime

  toJSON: () ->
    list = new Array();
    idx = 0;
    @.each (element) =>
      list[idx]=element.toJSON()
      idx+=1
    list