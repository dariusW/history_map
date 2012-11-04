#= require ./historyMap
#= require_tree ./templates
#= require_tree ./modules
#= require ./launch

window.HistoryMap =
  Models: {}
  Collections: {}
  Modules: {}
  Routers: {}
  Views: {}
  
class HistoryMapApp
  openedStory: null
  
  constructor: () ->
    @events = _.extend({}, Backbone.Events)
    @eventHandlers()
    
  eventHandlers: () ->
    @events.on "openStory", (model) =>
      @openedStory = model
      
      
    
    @events.on "closeStory", (model) =>
      @openedStory = null
    
  template: (name, context) ->
    JST["backbone/templates/#{name}"] context

  start: () ->
    
    # socket.direct.bind 'connected', () =>
    socket.socket.connection.bind 'connected', () =>
      @socketId = socket.socket.connection.socket_id 
      @events.trigger 'start',''
    
    
@app = new HistoryMapApp()
