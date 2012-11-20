@TimeLineControllsView = Backbone.View.extend
  el: "#run-panel"
  
  events:
    'click #step-next': 'stepNext'
    'click #step-prev': 'stepPrev'
    'click #play': 'togglePlay'
    
  stepNext: (animate) ->
    if(animate!=true)
      @stopPlay()
    
    if(!(@current.get("last")==true))
      @current.next.view.goToTime()
    else
      @stopPlay()
    
    
  stepPrev: () ->
    @stopPlay()
    if(!(@current.get("first")==true))
      @current.prev.view.goToTime()
    
  togglePlay: () ->
    if @run
      @stopPlay()
    else
      @run = true
      @$('#play>i').removeClass('icon-play').addClass('icon-pause')
      play = () ->
        app.events.trigger 'play-all', true
      @timeOut = setInterval play, @step
      
    
  stopPlay: () ->
    @run = false
    @$('#play>i').removeClass('icon-pause').addClass('icon-play')
    clearInterval(@timeOut)
  
  
  initialize: () ->
    @step = 1000
    @run = false
    @hide()
    @eventHandlers()
    
  hide: () ->
    @$el.hide()
    
  show: () ->
    @$el.show()
    
  eventHandlers: () ->
    app.events.on 'stop-all', () =>
      @stopPlay()
    
    app.events.on 'play-all', () =>
      @stepNext(true)
    
    socket.registerPrivate 'time_markers_done', (data) =>
      @show()
      @collection.models[0].view.goToTime()
      @current = @collection.models[0]
      
    app.events.on 'change-current-time', (@model) =>
      @current = model