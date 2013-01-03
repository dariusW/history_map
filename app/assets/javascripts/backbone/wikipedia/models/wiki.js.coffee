@Wiki = Backbone.Model.extend
  toJSON: () ->
    summary: @.get('summary')
    distance: @.get('distance')
    rank: @.get('rank')
    title: @.get('title')
    wikipediaUrl: @.get('wikipediaUrl')
    elevation: @.get('elevation')
    countryCode: @.get('countryCode')
    lng: @.get('lng')
    feature: @.get('feature')
    lang: @.get('lang')
    lat: @.get('lat')

@Wikis = Backbone.Collection.extend
  model: Wiki
