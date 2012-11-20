@StoryItemsListView = Backbone.View.extend
  el: '#display'
  
  initialize: () ->
    @collection = new StoryItems()
    @collection.on 'add', @addItem, @
    @handle()
    
  addItem: (model) ->
    item = new StoryItemView
      model: model
    @$el.append item.render()
    
  handle: () ->
    app.events.on 'openEditMode', (model) =>
      @model = model
      $.ajax
        method: "get"
        url: "/stories/#{@model.get('id')}"
        data: 
          socket_id: app.socketId
          edit: true
          
          
    socket.authRegisterPrivate 'collect_items', (items) =>
      @collection.add items
      
      
    app.events.on 'hideItemsList', () =>
      @$el.hide()

    app.events.on 'showItemsList', () =>
      @$el.show()
      
    app.events.on 'resetItemsList', () =>
      @collection.reset()
      @$el.html("")
      @$el.show()
      app.events.trigger 'openEditMode', @model
