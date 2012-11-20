@InfoEditorView = Backbone.View.extend
  className: "modal"
    
  ready: false
    
  events:
    "click #cancel" : "cancel"
    "click #mark": "mark"
    "click #update": "update"
    
  cancel: () ->
    @$el.modal "hide"
    app.events.trigger "showItemsList"
    app.events.trigger "clearTimeline"
  
  update: () ->
    @model.set("full_title", $('#info-form-full-title').val())
    @model.set("content", $('#info-form-content').val())
    
    item = 
        socket_id: app.socketId
    
    $.ajax
      type: "put"
      url: "/time_stops/#{@model.get('id')}"
      data:
        $.extend @model.toJSON(), item
      success: () => 
        app.events.trigger "clearTimeline"
        app.events.trigger "resetItemsList"
    
    @$el.modal "hide"
    
  mark: () ->
    @$el.modal "hide"
    $('#time_stop_view ul').append(app.template('storySetCenterButton', 'story', {text: "ok"}))
    $('#finish_modify_pos').click () =>
      $('#time_stop_view ul').html("");
      @marker.setMap null
      @$el.modal 
        backdrop: "static"
      @model.set('date',app.currentTime.attributes)
    @marker = new google.maps.Marker
      draggable: true
      map: map.map
      position: @model.position
    google.maps.event.addListener @marker, 'dragend', () =>
        @model.position = @marker.getPosition()
        @model.set('lat',@marker.getPosition().lat())
        @model.set('long',@marker.getPosition().lng())
    app.timeline.clickable=true
    app.timeline.collection.get(@model.get('date').date).view.goToTime()
    
      
  initialize: () ->
    $.ajax
      method: 'get'
      url: "/time_stops/#{@model.get('item_id')}"
      data:
        socket_id: app.socketId
        
    @handle()
    
  handle: () ->
    socket.authRegisterPrivate "stop_data_#{@model.get('item_id')}", (data) =>
      if(!@ready)
        @ready=true
        app.events.trigger "hideItemsList"
        @model = new InfoModel(data)
        @model.view = @
        @render()
    
    
  render: () ->
    tmp = app.template('infoForm','story', @model.toJSON())
    @$el.html(tmp)
    @$el.modal
      backdrop: "static"

