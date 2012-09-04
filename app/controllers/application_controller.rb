class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper



    logger.debug "#{@current_user}"
end
