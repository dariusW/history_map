#MODAL WITH TIME MARKER CONTENT
@TimeMarkerInfoView = Backbone.View.extend
  className: 'modal'
  
  events:
    "click #ok":"ok"
    
  initialize: () ->
    app.events.trigger 'stop-all', true
    @model.view_info = @
    @render()
    
  render: () ->
    temp = app.template 'markerMoreInfo','marker', @model.toJSON()
    @$el.html(temp)
    @$el.modal
      backdrop: true
    
  
  ok: (evt) ->
     @$el.modal 'hide'
     evt.preventDefault()
     