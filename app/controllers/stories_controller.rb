class StoriesController < ApplicationController
  # before_filter :correct_user, :only => [:update]
  before_filter :signed_in, :only => [:create,:destroy]
  
  def index
    if(!params[:id].nil?)
      return show
    end

    stories = nil

    if(params[:my])
      unless signed_in?
        render json: {}
      end

      stories = Story.find_all_by_user_id(current_user.id)

    else

      stories = Story.all
    end

    @hash = []

    idx = 0;
    stories.each do |s|
      item = {}
      item = s.attributes
      item[:top_boundry] = parseDate(s.top_boundry)
      item[:bottom_boundry] = parseDate(s.bottom_boundry)
      item[:precision_skip] = getSkip(s.precision)
      @hash[idx] = item
      # item[:socket_id] = params[:socket_id]
      idx+=1
      # Pusher['private-transmit'].trigger('stories_list', item.to_json, params[:socket_id])
      Pusher['public-transmit'].trigger("stories_list_#{params[:socket_id]}", item.to_json)
    end
    headers['Content-Type: "application/json"']

    render json: @hash
  end

  def show

    @hash = {}
    if(!params[:edit].nil? && params[:edit]=="true")

      story  = Story.find(params[:id])
      
      if current_user?(story.user)
        
        @hash = []
  
        idx = 0;
        story.time_markers.all.each do |m|
          type = ""
          if(m.singleton)
            type = "singleton"
          elsif(m.linear)
            type = "linear"
          else(m.linear)
            type = "polygon"
          end
          item = {title: m.full_title, type: type, id: idx, item_id: m.id}
          @hash[idx] = item
          idx+=1
        end
        story.time_stops.all.each do |m|
          item = {title: m.full_title, type: "info", id: idx, item_id: m.id}
          @hash[idx] = item
          idx+=1
        end
        Pusher['private-transmit'].trigger("collect_items_#{params[:socket_id]}", @hash.to_json)
        
        else
          @hash = {error: "restricted area"}
        end
    else

      story  = Story.find(params[:id])

      @hash[:time_markers] = story.time_markers.all.each do |m|
        Pusher['public-transmit'].trigger("time_marker_#{params[:socket_id]}", m.to_json)
        m[:times]  = m.time_markers_time.all
        items = []
        idx = 0
        first = true
        lastIdx = m[:times].length
        m[:times].each do |n|
          n[:positions] = n.time_markers_position.all
          items[idx] = n
          items[idx][:full_time] = toString(parseDate(items[idx][:time]), story.precision)
          if first
            items[idx][:first] = true
          first = false
          end
          lastIdx-=1
          if lastIdx == 0
            items[idx][:last] = true
          end
          if items.to_json.length>10240
            itm = items[idx]
            items[idx] = {}
            Pusher['public-transmit'].trigger("time_marker_times_#{params[:socket_id]}", items.to_json)
          idx = 0
          items = []
          items[idx] = itm
          end
          idx+=1
        end
        if !items.empty?
          Pusher['public-transmit'].trigger("time_marker_times_#{params[:socket_id]}", items.to_json)
        end

      end

      array = []
      idx = 0
      @hash[:time_stops] = story.time_stops.all.each do |n|
        array[idx] = n
        if array.to_json.length>10240
          itm = array[idx]
          array[idx] = {}
          Pusher['public-transmit'].trigger("time_stops_list_#{params[:socket_id]}", array.to_json)
        idx = 0
        array = []
        array[idx] = itm
        end
        idx += 1
      end
      if !array.empty?
        Pusher['public-transmit'].trigger("time_stops_list_#{params[:socket_id]}", array.to_json)
      end

      Pusher['public-transmit'].trigger("time_markers_done_#{params[:socket_id]}", {done: true}.to_json)
      headers['Content-Type: "application/json"']

    # Pusher['private-transmit'].trigger('stories_list', @hash.to_json, params[:socket_id])

    end

    render json: @hash

  end

  def timeLine
    story  = Story.find(params[:id])

    precision = story.precision

    @hash = []
    @push = []

    idx = 0
    pidx = 0
    limit = 70

    parsed_time = parseDate(story.bottom_boundry)
    parsed_time[:string_date] = toString(parsed_time, precision)
    parsed_time[:first] = true
    top_boundry = parseDate(story.top_boundry)

    while parsed_time[:date] <= top_boundry[:date]

      @hash[idx]=parsed_time
      @push[pidx]=parsed_time

      idx+=1
      pidx+=1

      parsed_time = addTimeUnit(parsed_time, precision)
      parsed_time[:string_date] = toString(parsed_time, precision)

      if(parsed_time[:date]==top_boundry[:date])
        parsed_time[:last] = true
      end

      if @push.to_json.length >=10240
        tmp = @push[pidx-1]
        @push[pidx-1]= {}

        # Pusher['private-transmit'].trigger('time_line', @push.to_json, params[:socket_id])
        if(params[:edit].nil?)
          Pusher['public-transmit'].trigger("time_line_#{params[:socket_id]}", @push.to_json)
        else
          Pusher['private-transmit'].trigger("time_line_#{params[:socket_id]}", @push.to_json)
        end
        @push=[]
        pidx=1
        @push[0] = tmp
      end

    end

    if pidx > 0
      # Pusher['private-transmit'].trigger('time_line', @push.to_json, params[:socket_id])
        if(params[:edit].nil?)
          Pusher['public-transmit'].trigger("time_line_#{params[:socket_id]}", @push.to_json)
        else
          Pusher['private-transmit'].trigger("time_line_#{params[:socket_id]}", @push.to_json)
        end
    end

    if(params[:edit].nil?)
      Pusher['public-transmit'].trigger("time_line_ready_#{params[:socket_id]}", {done: true})
    else
      Pusher['private-transmit'].trigger("time_line_ready_#{params[:socket_id]}", {done: true})
    end
    render json: @hash
  end

  def update
    @story = Story.find(params[:id])
    if @story.update_attributes(:bottom_boundry => params[:bottom_boundry][:date], :top_boundry => params[:top_boundry][:date], :full_title => params[:full_title], :precision => params[:precision], :content => params[:content], :lat => params[:lat], :long => params[:long])
      render json: {done: true}
    else
      render json: {done: false}
    end
  end

  def create
    @user = User.find(current_user.id)
    @res = {}
    if (sampleStory = @user.stories.create!(full_title: "No name", content: "", name: "HEAD", precision: "DAY", bottom_boundry: 141007140000, top_boundry: 141007150000,long: 20.095919, lat: 53.487407))
      @res = {done: true}
      
      
      Pusher['public-transmit'].trigger("stories_list_#{params[:socket_id]}", sampleStory.to_json)
    else
      @res = {done: false}
    end
    render json: @res
  end
  
  def destroy
    @story = Story.find(params[:id])
    @res = {done: false}
    if(@story.user.id==current_user.id)
      @story.destroy
      @res = {done: true}
    end
    render json: @res
  end


  private

  
  def signed_in
    render json: {error: "access denied"} unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    render json: {error: "access denied"}  unless current_user?(@user)
  end

end

# _{params[:socket_id]}