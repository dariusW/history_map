#= require ./historyMap
#= require_tree ./map
#= require_tree ./marker
#= require_tree ./stops
#= require_tree ./story
#= require_tree ./time
#= require_tree ./user
#= require_tree ./socket

class HistoryMapApp
  openedStory: null
  currentUser: null
  currentStory: null
  currentTime: null
  editMode: false
  
  constructor: () ->
    @events = _.extend({}, Backbone.Events)
    @events.on 'ready', @start
    
  eventHandlers: () ->
    @events.on "openStory", (model) =>
      @openedStory = model 
    
    @events.on "closeStory", (model) =>
      @openedStory = null
    
    @events.on "story_list_my", () =>
      @editMode = true
    
  template: (name, module, context) ->
    JST["backbone/#{module}/templates/#{name}"] context

  start: (authorised) =>
      @socketId = socket.socketId
      @socket = socket
      
      @map = new MapModule()
      window.map = @map
      
      new UserModule()
      
      new TimeUnitModule()
      
      new StoryModule()
      new TimeMarkerModule()
      new TimeStopModule()

      
      @eventHandlers()
      @events.trigger 'start'
      if authorised
        @events.trigger 'authorized_user'
    
    
@app = new HistoryMapApp()
