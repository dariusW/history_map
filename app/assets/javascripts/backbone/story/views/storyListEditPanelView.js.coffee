@StoryListEditPanelView = Backbone.View.extend
  className: "edit-panel-controll"
    
  initialize: () ->
    @eventHandlers()
    
  events: 
    "click #changeMode" : "changeMode"
    
  changeMode: () ->
    app.events.trigger 'story_list_my'
    
      
    
  eventHandlers: () ->
    app.events.on 'authorized_user_panel', () =>
      @render()  
      
    app.events.on 'story_list_my', () =>
      @$el.hide()
    
  render: () ->
    tmp = app.template 'editControl', 'story' , {model: true}
    @$el.html tmp
    $('#list-stories').append @$el