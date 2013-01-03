@StoryFormView = Backbone.View.extend
  className: "modal"
    
  events: 
    "click #update" : "update"
    "click #wiki" : "wiki"
    "click #cancel" : "cancel"
    "click #modify_pos": "modify_pos"
    "click #finish_modify_pos": "finish_modify_pos"
    "change #story-form-begin": "validate_date"
    "change #story-form-end": "validate_date"
    "change #story-form-precision": "change_precision"
    
  change_precision: (event) ->
    @model.set("precision", $(event.target).val())
    
  wiki: () ->
    $('#time_stop_view ul').append(app.template('storySetCenterButton', 'story', {text: "ok"}))
    $('#finish_modify_pos').click () =>
      alert()
    app.events.trigger 'wikiSeek', @model
    
    @$el.modal 'hide'
        
  update: () ->
    @model.set('full_title', @$("#story-full-title").val())
    @model.set('content', @$("#story-form-content").val())
    
    app.currentStory = @model
    
    item =
      socket_id: app.socketId
      
    $.ajax
      type: "put"
      url: "/stories/#{@model.get('id')}"
      data: 
        $.extend  @model.toJSON(), item
      success: () =>
        app.events.trigger "time_edit_line"    
    
    @$el.modal 'hide'
    
    
    
    
    
  cancel: () ->
    @$el.modal 'hide'
    
    
  validate_date: (event) ->
    date = $(event.target).val().replace(".","").replace(".","").replace(":","").replace(" ","")
    date = parseInt(date)
    $.ajax 
      method: "get"
      url: "/utils/date"
      data:
        id: $(event.target).attr('id')
        date: date
      success: (data) =>
        unless data.error?
          $("#"+data.id+"-string").html(data.date.string)
          if data.id.search("begin")>-1
            @model.set("bottom_boundry", data.date)
          if data.id.search("end")>-1
            @model.set("top_boundry", data.date)
        else
          $("#"+data.id+"-string").html(data.error)
          
    
  modify_pos: () -> 
    $('#time_stop_view ul').append(app.template('storySetCenterButton', 'story', {text: "ok"}))
    $('#finish_modify_pos').click () =>
      @finish_modify_pos()
    @$el.modal 'hide'
    @centerMarker = new google.maps.Marker
      draggable: yes
      position: @model.center
      map: map.map
    map.map.setCenter(@model.center)
    google.maps.event.addListener @centerMarker, 'dragend', () =>
      @model.center = @centerMarker.getPosition()
      @model.set('lat',@centerMarker.getPosition().lat())
      @model.set('long',@centerMarker.getPosition().lng())
      $('#lat_form').val(@centerMarker.getPosition().lat())
      $('#lng_form').val(@centerMarker.getPosition().lng())
      
  finish_modify_pos: (me) ->
    $('#time_stop_view ul').html("");
    @centerMarker.setMap null
    @$el.modal 
      backdrop: true
    
  
  initialize: () ->
    @model.editForm = @
    app.currentStory = @model
    @render()
    
  render: () ->
    tmp = app.template "storyForm", "story", @model.toJSON()
    @$el.html(tmp)
    @$el.modal
      backdrop: true
