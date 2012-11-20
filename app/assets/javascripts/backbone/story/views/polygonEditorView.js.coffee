@PolygonEditorView = Backbone.View.extend
  className: "modal"
    
  ready: false
    
  events:
    "click #cancel" : "cancel"
    "click #mark": "mark"
    "click #update": "update"
    "change #polygon-form-color": "getColor"
    
  getColor: (event) =>
    color = $("#polygon-form-color").val()
    $('#marker_color').html('<img src="http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|'+color+'"/>')
    
  cancel: () ->
    @close()
    @$el.modal "hide"
    app.events.trigger "showItemsList"
    app.events.trigger "clearTimeline"
    @line.setMap(null)
  
  update: () ->
    @model.set("full_title", $('#polygon-form-full-title').val())
    @model.set("color", $('#polygon-form-color').val())
    @model.set("content", $('#polygon-form-content').val())
    
    item = 
        socket_id: app.socketId
    
    i = $.extend @model.toJSON(), item
    
    $.ajax
      type: "put"
      url: "/time_markers/#{@model.get('id')}"
      data:
        $.extend @model.toJSON(), i
      success: () => 
        app.events.trigger "clearTimeline"
        app.events.trigger "resetItemsList"
    
        @$el.modal "hide"
    
        @$el.remove()
        
        @close()
  close: () ->
    app.events.off "display-time-clear"
    app.events.off "marker-panel-set"
    app.events.off "marker-panel-unset"
    app.events.off "marker-panel-ok"
    app.events.off "marker-panel-content-change"
    if(@line?)
      @line.setMap(null)
    
  mark: () ->
    @$el.modal "hide"
    
    if(@panel==null)
      @panel = new MarkerMapPanelView
        model: @model
        editor: @
    else
      @panel.render() 
    
    
    
    app.timeline.clickable=true

    @current = @model.collection.models[0]
    app.timeline.collection.get(@current.id).view.goToTime()

    
    # app.timeline.collection.get(@model.get('date').date).view.goToTime()
    
      
  initialize: () ->
    $.ajax
      method: 'get'
      url: "/time_markers/#{@model.get('item_id')}"
      data:
        socket_id: app.socketId
        
    @panel = null
    @currentListener = null
    @handle()
    
  handle: () ->
    socket.authRegisterPrivate "time_marker_polygon_#{@model.get('item_id')}", (data) =>
      if(!@ready)
        @ready=true
        app.events.trigger "hideItemsList"
        @model = new MarkerModel(data)
        @model.collection = new TimeMarkerTimes()
        @model.collection.on 'add', @setMarkerInTime, @
        @model.view = @
        @render()
        @getColor()
        
    socket.authRegisterPrivate "time_marker_polygon_time_#{@model.get('item_id')}", (data) =>
      @model.collection.add data
    
    app.events.on "display-time-clear", (time) =>
      @time = time
      best = null
      @model.collection.each (element) =>
        if element.get('destroy')? && element.get('destroy')
          
        else 
          if(time.id == element.id)
            best = element
            best.now = true
            app.events.trigger "edit-strict-marker-match", best
          if(best == null && time.id > element.id)
            best = element
            best.now = false
            app.events.trigger "edit-marker-match", best
          if(best != null && time.id > element.id && element.id > best.id)
            best = element
            best.now = false
            app.events.trigger "edit-marker-match", best
      
      
      @current = best# @model.collection.get(time.id)
      if(best == null)
        app.events.trigger "edit-marker-match", best
        @panel.setContent("")
        @unsetLine()

      else
        @panel.setContent @current.get("content")
        @setLine()
      
    
          
    app.events.on "marker-panel-ok", (item) =>
      if(@model.id = item.id)
        @$el.modal "show"
        if(@line)
          @line.setMap(null)
        
    app.events.on "marker-panel-unset", (item) =>
      if(@current.now? && @current.now == true)
        @current.set("destroy",true)
        app.events.trigger "time_unit_released", @time.id
        @time.view.goToTime()
        
    app.events.on "marker-panel-set", (item) =>
      
      if(@current? && @current.now? && @current.now == true)
        # #edycja
        @current.setPositions(@line)
        
      else
        # #nowy
        newTime = null
        if @current?
          newTime = new TimeMarkerTime
            content: @current.get("content")
            time_marker_id: @current.get("time_marker_id")
            time: @time.id

          newTime.setPositions(@line)
#              
#                           
        else
          newTime = new TimeMarkerTime
            content: ""
            time_marker_id: ""
            time: @time.id   
          copy = @model.collection.models[0]
          copy.positions.each (elem) =>
            newTime.positions.add elem
          
        
          
        @model.collection.add newTime
   
    app.events.on "marker-panel-content-change",  (item) =>
      if(@current?)
        @model.collection.get(@current.id).set("content",@panel.getContent())
        
  setLine: () ->
    if @line?
      @line.setMap(null)
    @line = new google.maps.Polygon
      editable: true
      geodesic: true
      map: map.map
      strokeWidth: 5
      visible: true
      path: @current.getPositionArray()     
      
  unsetLine: () ->
    if @line?
      @line.setMap(null)
        
  setMarkerInTime: (time) ->
    app.events.trigger "time_unit_placed", (time.id)
    
  render: () ->
    tmp = app.template('polygonForm','story', @model.toJSON())
    @$el.html(tmp)
    @$el.modal
      backdrop: "static"

