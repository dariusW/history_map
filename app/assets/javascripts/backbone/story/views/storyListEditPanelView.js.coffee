@StoryListEditPanelView = Backbone.View.extend
  className: "edit-panel-controll"
  tagName: 'li'
    
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
      
    
  render: () ->
    tmp = app.template 'editControl', 'story' , {model: true}
    @$el.html tmp
    $('#current_user').append @$el #list-stories