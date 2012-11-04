class StoriesController < ApplicationController
  def index
    if(!params[:id].nil?)
      return show
    end

    @hash = []

    stories = Story.all
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
    story  = Story.find(params[:id])

    @hash = {}
    @hash[:time_markers] = story.time_markers.all.each do |m| 
      Pusher['public-transmit'].trigger("time_marker_#{params[:socket_id]}", m.to_json)
      m[:times]  = m.time_markers_time.all
      items = []
      idx = 0
      first = true
      lastIdx = m[:times].length
      m[:times].each do |n|
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
          items[idx] = {}
          Pusher['public-transmit'].trigger("time_marker_times_#{params[:socket_id]}", items.to_json)
          idx = -1
          items = []
        end
        idx+=1
      end
      Pusher['public-transmit'].trigger("time_marker_times_#{params[:socket_id]}", items.to_json)
      
    end
    
      Pusher['public-transmit'].trigger("time_markers_done_#{params[:socket_id]}", {done: true}.to_json)
    headers['Content-Type: "application/json"']

    # Pusher['private-transmit'].trigger('stories_list', @hash.to_json, params[:socket_id])

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

      if pidx == limit
        pidx=0

        # Pusher['private-transmit'].trigger('time_line', @push.to_json, params[:socket_id])
        Pusher['public-transmit'].trigger("time_line_#{params[:socket_id]}", @push.to_json)

        @push = []
      end

    end

    if pidx > 0
      # Pusher['private-transmit'].trigger('time_line', @push.to_json, params[:socket_id])
      Pusher['public-transmit'].trigger("time_line_#{params[:socket_id]}", @push.to_json)
    end

    Pusher['public-transmit'].trigger("time_line_ready_#{params[:socket_id]}", {done: true})

    render json: @hash
  end
end

# _{params[:socket_id]}