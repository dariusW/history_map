@TimeUnitView = Backbone.View.extend

  initialize: () ->
    @model.view = @

  events:
    "click .time-unit" : "goToTime"
    
  goToTime: () ->
    #if @options.timeline.clickable
      app.currentTime = @model
      app.events.trigger "display-time-clear", @model
      app.events.trigger "display-time-#{@model.get('date')}", @model
      app.events.trigger "change-current-time", @model
      
  render: () ->
    @$el.html app.template 'timeUnit','time', @model.toJSON()
    @$el

  show: () ->
    @$el.show()
    
  hide: () ->
    @$el.hide()