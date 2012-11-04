class LoadContentsController < ApplicationController

  before_filter :set_controller_and_action_names
  def set_controller_and_action_names
    @current_controller = controller_name
    @current_action     = action_name
  end

  def welcome
    render partial: "welcome"
  end

  def welcome2
    hash = {}
    hash[:msg] =  "Hey new user!"
    Pusher['public-transmit'].trigger('welcome-new-user', hash.to_json)
    hash[:msg] =  "Autherised!"
    Pusher['public-transmit'].trigger('welcome-new-user', hash.to_json)
    hash[:msg] =  "Hey new user!"
  end
end
