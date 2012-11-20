@TimeStopView = Backbone.View.extend
  className: 'modal'
  
  initialize: () ->
    app.events.trigger 'stop-all', true
    @render()
       
  events:
    "click #ok": "ok"
  
  ok: (evt) ->
    @$el.modal 'hide'
    map.map.setCenter(@model.latlng)
    evt.preventDefault()
    
  render: () ->
    temp =  app.template( 'timeStopView','stops', @model.toJSON())
    @$el.html temp
    @$el.modal
      backdrop: true
    @$el
  
    