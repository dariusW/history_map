@UserView = Backbone.View.extend
  el: '#current_user'
  
  initialize: () ->
    @eventHandlers()
    
  eventHandlers: () ->
    
   socket.authRegisterPrivate 'my_data', (data) =>
     @model = new User data
     @model.view = @
     @render() 
     app.events.trigger 'authorized_user_panel'
    
   app.events.on 'authorized_user', () => 
      $.ajax 
        url: "/me"
        type: "get"
        data: 
          socket_id: app.socketId
    
    

  render: () ->
    tmp = app.template 'user', 'user', @model.toJSON()
    @$el.html tmp
