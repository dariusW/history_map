@User = Backbone.Model.extend
  toJSON: () ->
    email: @.get('email')
    id: @.get('id')
    name: @.get('name')

@Users = Backbone.Collection.extend
  model: User
