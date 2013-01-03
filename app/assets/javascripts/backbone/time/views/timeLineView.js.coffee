@TimeLineView = Backbone.View.extend
  el: "#time-line-inner" 
  clickable: false

  initialize: () ->
    app.timeline = @
    @eventHandlers()
    @collection = new TimeLine()
    @collection.on 'add', @addTimeUnit, @
    @collection.on 'remove', @removeTimeUnit, @
    
    @controlls = new TimeLineControllsView
      collection: @collection    
      
  removeTimeUnit: (data) ->
    $('#time-line-inner').width($('#time-line-inner').width()-11)
    
  addTimeUnit: (data) ->
    $('#time-line-inner').width(11+$('#time-line-inner').width())
    
    unit = new TimeUnitView
      model: data
      timeline: @
      
    _.each @collection.models, (element, index) =>
      if(element.id == data.id && index>0)
        @collection.models[index-1].next = element
        element.prev = @collection.models[index-1]
        
    @$el.append unit.render()
    
  eventHandlers: () ->
    socket.registerPrivate "time_line", (data) =>
       @collection.add data
       
    app.events.on "bind-with-time", (start,end, run) =>
      _.each @collection.models, (element) ->
        if(element.get('date') >= start && element.get('date') <= end)
          app.events.on "display-time-#{element.get('date')}", () ->
            run()
    
    app.events.on "display-time-clear", (model) =>
      _.each @collection.models, (element) =>
        element.view.$el.removeClass("current-time")
      model.view.$el.addClass("current-time")
      $('#current-time-string').html(model.get('string_date'))
        
    app.events.on "openStory", (model) =>
      @clickable = true
      @$el.html ""
      $.ajax 
        url: "/stories/#{model.get('id')}/timeline"
        type: "get"
        data: 
          socket_id: app.socketId
          
    app.events.on "time_unit_placed", (time) =>
      @collection.get(time).view.$el.addClass("markersSuplied")
      
    app.events.on "time_unit_released", (time) =>
      @collection.get(time).view.$el.removeClass("markersSuplied")
      
    app.events.on "closeStory", () =>
      @$el.html ""
      $('#current-time-string').html ""
      @initialize()
      
    app.events.on "clearTimeline", () =>
      @collection.each (element)=>
        element.view.$el.removeClass("current-time")
        element.view.$el.removeClass("markersSuplied")
      $('#current-time-string').html("")
      app.currentTime = null  
      
      
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