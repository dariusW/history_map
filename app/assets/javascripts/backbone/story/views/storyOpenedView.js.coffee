@StoryOpenedView = Backbone.View.extend
  el: '#opened-title'
  tagName: "li"
  
  initialize: () ->
      @eventHandlers()
     
  events:
    "click .opened-story h3" : "storyMoreInfo"
    "click #point": "createPoint"
    "click #line": "createLine"
    "click #polygon": "createPolygon"
    "click #info": "createInfo"
    "click #remove": "removeStory"
    
  createPoint: () ->
    $.ajax
      type: 'post'
      url: "/time_markers"
      data:
        socket_id: socket.socketId 
        id: app.currentStory.id
        time: @model.get('bottom_boundry').date
        lat: @model.get('lat')
        lng: @model.get('long') 
        type: 'point'
      success: () =>
        app.events.trigger "resetItemsList"
        
  createLine: () ->
    
    $.ajax
      type: 'post'
      url: "/time_markers"
      data:
        socket_id: socket.socketId 
        id: app.currentStory.id
        time: @model.get('bottom_boundry').date
        lat: @model.get('lat')
        lng: @model.get('long') 
        type: 'line'
      success: () =>
        app.events.trigger "resetItemsList"
        
  createPolygon: () ->
    
    $.ajax
      type: 'post'
      url: "/time_markers"
      data:
        socket_id: socket.socketId 
        id: app.currentStory.id
        time: @model.get('bottom_boundry').date
        lat: @model.get('lat')
        lng: @model.get('long') 
        type: 'polygon'
      success: () =>
        app.events.trigger "resetItemsList"
        
  createInfo: () ->
    
    $.ajax
      type: 'post'
      url: "/time_stops"
      data:
        socket_id: socket.socketId 
        id: app.currentStory.id
        time: @model.get('bottom_boundry').date
        lat: @model.get('lat')
        lng: @model.get('long') 
      success: () =>
        app.events.trigger "resetItemsList"
        
  removeStory: () ->
    $.ajax
      type: 'delete'
      url: "/stories/#{@model.get('id')}"
      data:
        socket_id: socket.socketId 
        id: app.currentStory.id
        time: @model.get('bottom_boundry').date
        lat: @model.get('lat')
        lng: @model.get('long') 
      success: (data) =>
        window.location = "../"
        
      
  storyMoreInfo: () ->
    unless app.editMode 
      new StoryMoreInfoView
        model: @model
    else
      if app.currentStory?
        @model = app.currentStory
      new StoryFormView
        model: @model
      
      
  eventHandlers: () ->   
    app.events.on 'hideItemsList', () =>
      @.$('#buttons').hide()

    app.events.on 'showItemsList', () =>
      @.$('#buttons').show()
      
    app.events.on 'openStory', (model) =>
      @model = model
      @model.set('opened', true)
      map.map.setCenter(model.center)
      @render()
      
    app.events.on 'openEditMode', (model) =>
      @model = model
      @model.set('opened', true)
      map.map.setCenter(model.center)
      @render()

    app.events.on 'closeStory', (model) =>
      @clear()     
      
    socket.registerPrivate 'time_line_ready', (data) =>
      $.ajax
        url: "/stories/#{app.openedStory.get('id')}"
        type: "get"
        data: 
          socket_id: app.socketId
    
    
  render: () ->
    @$el.html app.template 'storyOpenedTitle', 'story', @model.toJSON()
    @$el
    
  clear: () ->
    @$el.html ""