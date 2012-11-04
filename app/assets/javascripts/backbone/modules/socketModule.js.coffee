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
    @direct = @socket.subscribe(@defaults.privateChannel)
    @broadcast = @socket.subscribe(@defaults.publicChannel)
    # @broadcast.bind 'stories_list', (data) =>
      # alert(data)
    
  
  registerPublic: (event, callback) =>
      @broadcast.bind event, callback
    
    
  registerPrivate: (event, callback) ->
    app.events.on "start", () =>
      @broadcast.bind "#{event}_#{app.socketId}", callback
    
@socket = new SocketModule()
