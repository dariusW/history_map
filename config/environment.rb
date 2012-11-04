# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
HistoryMap::Application.initialize!

require 'pusher' 
Pusher.app_id = '30062' 
Pusher.key = 'b2c8a1f93ceea7e108b7' 
Pusher.secret = '26cc97dfc5cab91d38fc'