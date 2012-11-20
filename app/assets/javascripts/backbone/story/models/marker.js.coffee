@MarkerModel = Backbone.Model.extend
  initialize: () ->
    @collection = new TimeMarkerTimes()
    
  toJSON: () ->
    content: @.get('content')
    full_title: @.get('full_title')
    color: @.get('color')
    singleton: @.get('singleton')
    position: @collection.toJSON()
    destroy: @.get('destroy') if @.get('destroy')?
    
@MarkerModels = Backbone.Collection.extend
  model: MarkerModel
