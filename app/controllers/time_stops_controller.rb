class TimeStopsController < ApplicationController
  before_filter :permission_check, :only => [:show, :update]
  before_filter :signed_in
  
  def show
    item = TimeStop.find(params[:id])
    item[:date] = parseDate(item[:time])
    
    Pusher["private-transmit"].trigger("stop_data_#{params[:id]}_#{params[:socket_id]}", item.to_json)
    render json: item
  end
  
  
  def destroy
    @info = TimeStop.find(params[:id])
    @res = {done: false}
    if @info.story.user.id == current_user.id
      @info.destroy
      @res = {done: true}
    end
    render json: @res
  end
  
  def update
    @info = TimeStop.find(params[:id])
    if @info.update_attributes(:time => params[:date][:date], :full_title => params[:full_title], :content => params[:content], :lat => params[:lat], :long => params[:long])
      render json: {done: true}
    else
      render json: {done: false}
    end
  end
  
  def create
    @story = Story.find(params[:id])
    @res ={} 
    if current_user? @story.user
      if(item = @story.time_stops.create!(time: params[:time], long: params[:lng], lat: params[:lat], full_title: "Info - no name", content: ""))
        @res = {done: true}
      end
    else
      @res ={done: false}
    end
    render json: @res
  end
  
  private
  def permission_check
    timeStop = TimeStop.find(params[:id])
    if(!current_user?(timeStop.story.user))
      render json: {error: "restricted area"}
    end
  end
  
  
  def signed_in
    unless signed_in?
      render json: {error: "restricted area"} 
    end
  end
end
