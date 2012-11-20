@MarkerMapPanelView = Backbone.View.extend
  el: "#time_stop_view ul"
  
  tagName: "li"
  
  events: 
    "click #ok": "ok"
    "click #set": "set"
    "click #unset": "unset"
    "change #panel-marker-info": "contentChange"
    
  ok: () ->
    app.events.trigger "marker-panel-ok", @model
    @$el.html("")
    
  set: () ->
    if(@setVal)
      app.events.trigger "marker-panel-set", @model
      
  unset: () ->
    if(@unsetVal)
      app.events.trigger "marker-panel-unset", @model
  
  contentChange: () ->
    app.events.trigger "marker-panel-content-change", @model
  
  initialize: () ->
    @editor = @options.editor
    
    
    @render()
    
    
    app.events.on "edit-strict-marker-match", (item)  =>
      @setStatus true
      @unsetStatus true
      
    app.events.on "edit-marker-match", (item) =>
      @setStatus true
      @unsetStatus false
      
  setStatus: (status) ->
    if(status)
      @.$('#set').removeClass("disabled")
    else
      @.$('#set').addClass("disabled")
    @setVal = status
    
  unsetStatus: (status) ->
    if(status)
      @.$('#unset').removeClass("disabled")
    else
      @.$('#unset').addClass("disabled")
    @unsetVal = status
    
  setContent: (text) ->
    @.$('#panel-marker-info').val(text)
    
  getContent: () ->
    @.$('#panel-marker-info').val()
  
  render: () ->
    tmp = app.template 'markerMapPanel', 'story', {}
    @$el.html tmp
    @$el