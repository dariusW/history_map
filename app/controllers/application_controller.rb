class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include StoryDateHelper



    logger.debug "#{@current_user}"
end
