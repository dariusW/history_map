TimeUnit = Backbone.Model.extend
  initialize: ()->
    @id = @.get('date')

  toJSON: () ->
    date: @.get('date')
    c: @.get('c')
    minutes: @.get('minutes')
    hours:  @.get('hours')
    days: @.get("days")
    years: @.get("years")
    isLeap: @.get("isLeap")
    decade: @.get("decade")
    age: @.get("age")
    string_date: @.get('string_date')
    
TimeLine = Backbone.Collection.extend
  model: TimeUnit

TimeUnitView = Backbone.View.extend
  initialize: () ->
    @model.view = @

  events:
    "click .time-unit" : "goToTime"
    
  goToTime: () ->
    app.events.trigger "display-time-clear", @model
    app.events.trigger "display-time-#{@model.get('date')}", @model
    app.events.trigger "change-current-time", @model
    
  render: () ->
    @$el.html app.template 'timeUnit', @model.toJSON()
    @$el

  show: () ->
    @$el.show()
    
  hide: () ->
    @$el.hide()
    
TimeLineControllsView = Backbone.View.extend
  el: "#run-panel"
  
  events:
    'click #step-next': 'stepNext'
    'click #step-prev': 'stepPrev'
    'click #play': 'togglePlay'
    
  stepNext: () ->
    if(!(@current.get("last")==true))
      @current.next.view.goToTime()
    
  stepPrev: () ->
    if(!(@current.get("first")==true))
      @current.prev.view.goToTime()
    
  togglePlay: () ->
    if @run
      @stopPlay()
    else
      @run = true
      runFunction = () =>
        @stepNext() 
        
      @timeOut = setTimeout
      
    
  stopPlay: () ->
    @run = false
  
  
  initialize: () ->
    @run = false
    @hide()
    @eventHandlers()
    
  hide: () ->
    @$el.hide()
    
  show: () ->
    @$el.show()
    
  eventHandlers: () ->
    socket.registerPrivate 'time_markers_done', (data) =>
      @show()
      @collection.models[0].view.goToTime()
      @current = @collection.models[0]
      
    app.events.on 'change-current-time', (@model) =>
      @current = model
    
    
TimeLineView = Backbone.View.extend
  el: "#time-line-inner" 

  initialize: () ->
    @eventHandlers()
    @collection = new TimeLine()
    @controlls = new TimeLineControllsView
      collection: @collection    
    
    @collection.on 'add', @addTimeUnit, @
    
  addTimeUnit: (data) ->
    unit = new TimeUnitView
      model: data
      
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
      @$el.html ""
      $.ajax 
        url: "/stories/#{model.get('id')}/timeline"
        type: "get"
        data: 
          socket_id: app.socketId
          
    app.events.on "time_unit_placed", (time) =>
      @collection.get(time).view.$el.addClass("markersSuplied")
      
    app.events.on "closeStory", () =>
      @$el.html ""
      $('#current-time-string').html ""
    

    
class TimeUnitModule
  constructor: () ->
    @TimeLineView = new TimeLineView()

$ ->
  timeUnitModule = new TimeUnitModule()

# _#{app.sockedId}