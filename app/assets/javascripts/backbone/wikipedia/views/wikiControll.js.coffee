@WikiControll = Backbone.View.extend

  initialize: () ->
    @collection = new Wikis()
    @collection.on 'add', @addWiki, @
    @collection.on 'remove', @removeWiki, @
    app.events.on 'wikiSeek', (story) =>
      $.ajax
        type: "get"
        url: "http://api.geonames.org/findNearbyWikipediaJSON"
        data: 
          lat: story.get('lat')
          lng: story.get('long')
          username: "livehistory"
        success: (data) =>
          _.each data.geonames, (i) =>
            @collection.add i
    
    
  addWiki: (data) ->
    wikiV = new WikiInfo
      model: data
    wikiV.render()
    
  removeWiki: (data) ->
    
