@StoryView = Backbone.View.extend
  tagName: 'li'
  className: 'story-item'
    
  initialize: () ->
    @model.view = @
    @eventsHandlers()
    
  eventsHandlers: () ->
    app.events.on "closeStory", () =>
      @model.set('opened', false)
  
  render: () ->
    @$el.html app.template 'storyItem', 'story', @model.toJSON()
    @$el
    
  events:
    "click a" : "storyMoreInfo"
  
  show: () ->
    @$el.show()
    
  hide: () ->
    @$el.hide()
    
  storyMoreInfo: () ->
    unless app.editMode
      new StoryMoreInfoView
        model: @model
    else
      app.currentStory = @model
      new StoryItemsListView()
      # new TimeEditLineView()
      new StoryFormView
        model: @model
      app.events.trigger 'openEditMode', @model
      app.events.trigger "time_edit_line"
      $('.edit-panel-controll').remove();
