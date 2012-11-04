Story = Backbone.Model.extend
  initialize: () ->
    @center = new google.maps.LatLng(@.get('lat'), @.get('long'))
    @.set('opened',false)

  toJSON: () ->
    id: @.get('id')
    name: @.get('name')
    full_title: @.get('full_title')
    precision: @.get('precision')
    published: @.get('published')
    content: @.get('content')
    top_boundry: @.get('top_boundry')
    bottom_boundry: @.get('bottom_boundry')
    lat: @.get('lat')
    long: @.get('long')
    opened: @.get('opened')
    
Stories = Backbone.Collection.extend
  model: Story
    
StoryView = Backbone.View.extend

  initialize: () ->
    @model.view = @
    @eventsHandlers()
    
  eventsHandlers: () ->
    app.events.on "closeStory", () =>
      @model.set('opened', false)
  
  render: () ->
    @$el.html app.template 'storyItem', @model.toJSON()
    @$el
    
  events:
    "click .story-item" : "storyMoreInfo"
  
  show: () ->
    @$el.show()
    
  hide: () ->
    @$el.hide()
    
  storyMoreInfo: () ->
    new StoryMoreInfoView
      model: @model
    
StoryListView = Backbone.View.extend
  el: '#story-list'
  
  initialize: () ->
    @collection = new Stories()
    @collection.on 'add', @addStory, @
    @eventHandlers()
    
  addStory: (story) ->
    storyView = new StoryView
      model: story
    @$el.append storyView.render()
    
  hide: () ->
    $('#menuContainer').hide()
    
  show: () ->
    $('#menuContainer').show()
        
  eventHandlers: () ->
    socket.registerPrivate "stories_list", (data) =>
      @collection.add data
    # app.events.on 'stories_list', @alert
      
    app.events.on 'start', (story) =>
      $.ajax 
        url: "/stories"
        type: "get"
        data: 
          socket_id: app.socketId
          
    app.events.on 'openStory', (model) =>
      @hide()       
    
    
    app.events.on 'closeStory', (model) =>
      @show()       
      
      
StoryOpenedView = Backbone.View.extend
  el: '#opened-title'
  
  initialize: () ->
      @eventHandlers()
     
  events:
    "click .opened-story" : "storyMoreInfo"
      
  storyMoreInfo: () ->
    new StoryMoreInfoView
      model: @model
    
  eventHandlers: () ->   
    app.events.on 'openStory', (model) =>
      @model = model
      @model.set('opened', true)
      map.map.setCenter(model.center)
      @render()
      

    app.events.on 'closeStory', (model) =>
      @clear()     
      
    socket.registerPrivate 'time_line_ready', (data) =>
      $.ajax
        url: "/stories/#{app.openedStory.get('id')}"
        type: "get"
        data: 
          socket_id: app.socketId
    
    
  render: () ->
    @$el.html app.template 'storyOpenedTitle', @model.toJSON()
    @$el
    
  clear: () ->
    @$el.html ""
  
             
StoryMoreInfoView = Backbone.View.extend
  className: 'modal'
    
  events:
    "keypress input": "openWithEnter"
    "click #open":"open"
    "click #close":"close"
    "click #cancel": "cancel"
  
  initialize: () ->
    @render()

  open: (evt) ->
      app.events.trigger 'openStory', @model
      @$el.modal 'hide'
      evt.preventDefault()
      
  
  close: (evt) ->
      app.events.trigger 'closeStory', @model
      @$el.modal 'hide'
      evt.preventDefault()
      
  cancel: (evt) ->
     @$el.modal 'hide'
     evt.preventDefault()

  openWithEnter: (evt) ->
    if evt.keyCode is 13
      @done evt

  render: () ->
    temp = app.template 'storyMoreInfo', @model.toJSON()
    @$el.html(temp)
    @$el.modal
      backdrop: true

class StoryModule
  constructor: () ->
    @story = new Story()
    @storyListView = new StoryListView()
    @storyOpenedView = new StoryOpenedView()
      

$ ->
  storyModule = new StoryModule


# _#{app.sockedId}