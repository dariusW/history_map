class SocketModule 
  defaults: 
    authentificationUrl:"/auth"
    socketKey: "b2c8a1f93ceea7e108b7"
    privateChannel: "private-transmit"
    publicChannel: "public-transmit"

  constructor: () -> 
    @pusher = Pusher
    @pusher.channel_auth_endpoint = @defaults.authentificationUrl
    
    @socket = new @pusher(@defaults.socketKey)
    @socket.connection.bind 'connected', () =>
      @socketId = @socket.connection.socket_id    
    @privateConnection = @socket.subscribe(@defaults.privateChannel) 
    @authRegisterPublic "pusher:subscription_succeeded", () =>
      app.events.trigger "ready", true
    @authRegisterPublic "pusher:subscription_error", () =>
      app.events.trigger "ready", false
    @publicConnection = @socket.subscribe(@defaults.publicChannel)
    
    
  
  registerPublic: (event, callback) =>
      @privateConnection.bind event, callback
    
    
  registerPrivate: (event, callback) ->
      @publicConnection.bind "#{event}_#{@socketId}", callback
    
  authRegisterPublic: (event, callback) =>
      @privateConnection.bind event, callback
    
    
  authRegisterPrivate: (event, callback) ->
      @privateConnection.bind "#{event}_#{@socketId}", callback
   
@SocketModule = SocketModule   
   
$ =>    
  @socket = new SocketModule()
