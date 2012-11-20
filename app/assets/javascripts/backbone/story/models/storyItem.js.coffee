@StoryItem = Backbone.Model.extend
  toJSON: () ->
    title: @.get('title')
    type: @.get('type')
    id: @.get('id')
    
@StoryItems = Backbone.Collection.extend
  model: StoryItem