@Story = Backbone.Model.extend
  initialize: () ->
    @center = new google.maps.LatLng(@.get('lat'), @.get('long'))
    @.set('opened',false)

  toJSON: () ->
    id: @.get('id')
    name: @.get('name')
    full_title: @.get('full_title')
    precision: @.get('precision')
    published: @.get('published')
    content: @.get('content')
    top_boundry: @.get('top_boundry')
    bottom_boundry: @.get('bottom_boundry')
    lat: @.get('lat')
    long: @.get('long')
    opened: @.get('opened')
    editMode: @.get('editMode')
    
@Stories = Backbone.Collection.extend
  model: Story
    