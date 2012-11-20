@StoryListView = Backbone.View.extend
  el: '#story-list'
  
  initialize: () ->
    @collection = new Stories()
    @collection.on 'add', @addStory, @
    @collection.on 'remove', @removeStory, @
    @eventHandlers()
    
  addStory: (story) ->
    story.set("editMode",app.editMode)
    storyView = new StoryView
      model: story
    @$el.append storyView.render()
    
  removeStory: (story) ->
    story.view.$el.remove()
    
  hide: () ->
    $('#menuContainer').hide()
    
  show: () ->
    $('#menuContainer').show()
        
  eventHandlers: () ->
    socket.registerPrivate "stories_list", (data) =>
      @collection.add data
    # app.events.on 'stories_list', @alert
    
    app.events.on 'story_list_my', () =>
      @collection.reset()
      $('#story-list>.nav-header').text("My Stories")
      $('.story-item').remove()
      $('#list-stories').append("<a href='#' id='create_new'>ADD NEW</a>")
      $('#create_new').click () =>
        $.ajax
          type: 'post'
          url: "/stories"
          data:
            socket_id: socket.socketId
      $.ajax
        url: "/stories?my=true"
        type: "get"
        data:
          socket_id: socket.socketId
          
          
      
    app.events.on 'start', (story) =>
      $.ajax 
        url: "/stories"
        type: "get"
        data: 
          socket_id: socket.socketId
          
    app.events.on 'openStory', (model) =>
      @hide()       
    
    app.events.on 'openEditMode', () =>
      @hide()
    
    app.events.on 'closeStory', (model) =>
      @show()     