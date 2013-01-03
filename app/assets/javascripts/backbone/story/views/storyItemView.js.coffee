@StoryItemView = Backbone.View.extend
  className: "storyItem"

  events:
    "click strong": "openEditor"
    "click #remove": "remove"
    
  openEditor: () ->
    if @model.get('type') == 'info'
      new InfoEditorView
        model: @model
    if @model.get('type') == 'singleton'
      new SingletonEditorView
        model: @model
    if @model.get('type') == 'linear'
      new LinearEditorView
        model: @model
    if @model.get('type') == 'polygon'
      new PolygonEditorView
        model: @model
  
  remove: () ->
    if @model.get('type') == 'info'
      $.ajax
        type: 'delete'
        url: "/time_stops/#{@model.get('item_id')}"
        data:
          socket_id: socket.socketId 
        success: (data) =>
          app.events.trigger "resetItemsList"
          
    else
      $.ajax
        type: 'delete'
        url: "/time_markers/#{@model.get('item_id')}"
        data:
          socket_id: socket.socketId 
        success: (data) =>
          app.events.trigger "resetItemsList"
  
  initialize: () ->
    @model.view = @
    
  render: () ->
    tmp = app.template('storyItemItem', 'story', @model.toJSON())
    @$el.html(tmp)
    @$el
