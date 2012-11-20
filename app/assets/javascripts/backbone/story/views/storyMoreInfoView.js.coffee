@StoryMoreInfoView = Backbone.View.extend
  className: 'modal'
    
  events:
    "keypress input": "openWithEnter"
    "click #open":"open"
    "click #close":"close"
    "click #cancel": "cancel"
  
  initialize: () ->
    app.events.trigger 'stop-all', true
    @render()

  open: (evt) ->
      app.events.trigger 'openStory', @model
      @$el.modal 'hide'
      evt.preventDefault()
      
  
  close: (evt) ->
      app.events.trigger 'closeStory', @model
      @$el.modal 'hide'
      window.location = "../"
      evt.preventDefault()
      
  cancel: (evt) ->
     @$el.modal 'hide'
     evt.preventDefault()

  openWithEnter: (evt) ->
    if evt.keyCode is 13
      @done evt

  render: () ->
    temp = app.template 'storyMoreInfo', 'story', @model.toJSON()
    @$el.html(temp)
    @$el.modal
      backdrop: true
