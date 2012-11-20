@TimeEditLineView = Backbone.View.extend
  el: "#time-line-inner" 
  currentTime: null


  initialize: () ->
    @eventHandlers()
    @collection = new TimeLine()    
    @collection.on 'add', @addTimeUnit, @
    app.events.trigger "time_edit_line"
    
    
  addTimeUnit: (data) ->
    unit = new TimeUnitView
      model: data
    @$el.append unit.render()
    
  eventHandlers: () ->
    socket.authRegisterPrivate "time_line", (data) =>
       @collection.add data
       
    app.events.on "time_edit_line", () =>
      @model = app.currentStory
      @collection.reset() 
      @$el.html ""
      $.ajax 
        url: "/stories/#{@model.get('id')}/timeline"
        type: "get"
        data: 
          socket_id: app.socketId
          edit: true
  
    app.events.on "display-time-clear", (clicked) =>
      
