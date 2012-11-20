@SingletonEditorView = Backbone.View.extend
  className: "modal"
    
  ready: false
    
  events:
    "click #cancel" : "cancel"
    "click #mark": "mark"
    "click #update": "update"
    "change #singleton-form-color": "getColor"
    
  getColor: (event) =>
    color = $("#singleton-form-color").val()
    $('#marker_color').html('<img src="http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|'+color+'"/>')
    
  cancel: () ->
    @$el.modal "hide"
    app.events.trigger "showItemsList"
    app.events.trigger "clearTimeline"
  
  update: () ->
    @model.set("full_title", $('#singleton-form-full-title').val())
    @model.set("color", $('#singleton-form-color').val())
    @model.set("content", $('#singleton-form-content').val())
    
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
        @close()
    
        @$el.modal "hide"
    
        @$el.remove()
    
  mark: () ->
    @$el.modal "hide"
    
    if(@panel==null)
      @panel = new MarkerMapPanelView
        model: @model
        editor: @
    else
      @panel.render() 
    
    @marker = new google.maps.Marker
      draggable: true
      map: map.map
      visible: false
          
    app.timeline.clickable=true
    
    @current = @model.collection.models[0]
    app.timeline.collection.get(@current.id).view.goToTime()
    
    # app.timeline.collection.get(@model.get('date').date).view.goToTime()
    
  close: () ->
    app.events.off "display-time-clear"
    app.events.off "marker-panel-set"
    app.events.off "marker-panel-unset"
    app.events.off "marker-panel-ok"
    app.events.off "marker-panel-content-change"
        
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
    socket.authRegisterPrivate "time_marker_single_#{@model.get('item_id')}", (data) =>
      if(!@ready)
        @ready=true
        app.events.trigger "hideItemsList"
        @model = new MarkerModel(data)
        @model.collection = new TimeMarkerTimes()
        @model.collection.on 'add', @setMarkerInTime, @
        @model.view = @
        @render()
        @getColor()
        
    socket.authRegisterPrivate "time_marker_single_time_#{@model.get('item_id')}", (data) =>
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
        @marker.setVisible(false)
        @panel.setContent("")
        if(@currentListener != null)
          google.maps.event.removeListener(@currentListener)
      else
        @marker.setPosition(@current.position.latlng)
        map.map.setCenter(@current.position.latlng)
        @marker.setVisible(true)
        @panel.setContent @current.get("content")
        if(@currentListener != null)
          google.maps.event.removeListener(@currentListener)
        @currentListener = google.maps.event.addListener @marker, 'dragend', () =>
          # @current.position.latlng = @marker.getPosition()
          # @current.position.set('lat',@marker.getPosition().lat())
          # @current.position.set('lng',@marker.getPosition().lng())
    
          
    app.events.on "marker-panel-ok", (item) =>
      if(@model.id = item.id)
        @$el.modal "show"
        @marker.setMap(null)
        
        
    app.events.on "marker-panel-unset", (item) =>
      if(@current.now? && @current.now == true)
        @current.set("destroy",true)
        app.events.trigger "time_unit_released", @time.id
        @time.view.goToTime()
        
    app.events.on "marker-panel-set", (item) =>
      if(@current? && @current.now? && 
          @current.now == true)
        @current.position.latlng = @marker.getPosition()
        @current.position.set('lat',@marker.getPosition().lat())
        @current.position.set('lng',@marker.getPosition().lng())
      else
      
        newTime = null
        if @current?
          newTime = new TimeMarkerTime
            content: @current.get("content")
            time_marker_id: @current.get("time_marker_id")
            time: @time.id
            
        else
          newTime = new TimeMarkerTime
            content: ""
            time_marker_id: ""
            time: @time.id
          @marker.setVisible true
        lt = @marker.getPosition().lat()
        lg = @marker.getPosition().lng()
        newPos = new TimeMarkerPosition
          lat:lt
          lng:lg
          
        newTime.positions.add newPos
          
        @model.collection.add newTime
   
    app.events.on "marker-panel-content-change",  (item) =>
      if(@current?)
        @model.collection.get(@current.id).set("content",@panel.getContent())
        
  setMarkerInTime: (time) ->
    app.events.trigger "time_unit_placed", (time.id)
    
  render: () ->
    tmp = app.template('singletonForm','story', @model.toJSON())
    @$el.html(tmp)
    @$el.modal
      backdrop: "static"

