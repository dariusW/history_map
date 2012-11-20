class TimeMarkersController < ApplicationController
  before_filter :permission_check, :only => [:show, :update]
  before_filter :signed_in
  def show
    item = TimeMarker.find(params[:id])
    if item.singleton?
      Pusher['private-transmit'].trigger("time_marker_single_#{item.id}_#{params[:socket_id]}", item.to_json)
    elsif item.linear?
      Pusher['private-transmit'].trigger("time_marker_linear_#{item.id}_#{params[:socket_id]}", item.to_json)
    elsif item.polygon?
      Pusher['private-transmit'].trigger("time_marker_polygon_#{item.id}_#{params[:socket_id]}", item.to_json)
    end
    item.time_markers_time.all
    toSend = []
    idx=0
    item[:time] = item.time_markers_time.all.each do |m|
      m[:positions] = m.time_markers_position.order("ordering").all
      toSend[idx] = m
      if toSend.to_json.length>= 10240
        last = toSend[idx]
        toSend[idx]= {}
        if item.singleton?
          Pusher['private-transmit'].trigger("time_marker_single_time_#{item.id}_#{params[:socket_id]}", toSend.to_json)
        elsif item.linear?
          Pusher['private-transmit'].trigger("time_marker_linear_time_#{item.id}_#{params[:socket_id]}", toSend.to_json)
        elsif item.polygon?
          Pusher['private-transmit'].trigger("time_marker_polygon_time_#{item.id}_#{params[:socket_id]}", toSend.to_json)
        end
      toSend = []
      toSend[0] = last
      idx=0
      end
      idx+=1
    end
    if item.singleton?
      Pusher['private-transmit'].trigger("time_marker_single_time_#{item.id}_#{params[:socket_id]}", toSend.to_json)
    elsif item.linear?
      Pusher['private-transmit'].trigger("time_marker_linear_time_#{item.id}_#{params[:socket_id]}", toSend.to_json)
    elsif item.polygon?
      Pusher['private-transmit'].trigger("time_marker_polygon_time_#{item.id}_#{params[:socket_id]}", toSend.to_json)
    end

    render json: item
  end

  def destroy
    @info = TimeMarker.find(params[:id])
    @res = {done: false}
    if @info.story.user.id == current_user.id
      @info.destroy
      @res = {done: true}
    end
    render json: @res
  end

  def update
    @info = TimeMarker.find(params[:id])
    if !params[:destroy].nil? && Boolean(params[:destroy])
      @info.destroy
      render json: {done: true}
    elsif @info.update_attributes(:full_title => params[:full_title], :content => params[:content], :color => params[:color])
      logger.debug "UPDATED TimeMarker "+@info.full_title
      for idx in 0...params[:position].length
        p = params[:position][String(idx)]
        id = p[:id]
        if(!id.nil?)
          marker = TimeMarkersTime.find(id)

          if !p[:destroy].nil? && Boolean(p[:destroy] && marker.time_marker.id == @info.id)
            marker.destroy
            logger.debug "DESTROY TimeMarkerTime "+String(marker.time)
          elsif(marker.time_marker.id == @info.id)
            if marker.update_attributes(:content => p[:content], :time =>p[:time])
              logger.debug "UPDATED TimeMarkerTime "+String(marker.time)
            else
              logger.debug "ERROR TimeMarkerTime "+String(marker.time)
            end
            marker.time_markers_position.all.each do |l|
              l.destroy
            end
            
            for idx2 in 0...p[:position].length
              m = p[:position][String(idx2)]
              # mid = m[:id]
              # if(!mid.nil?)
                # position = TimeMarkersPosition.find(mid)
                # if !m[:destroy].nil? && Boolean(m[:destroy] && position.time_markers_time.id == marker.id)
                # position.destroy
                # elsif(position.time_markers_time.id == marker.id)
                  # if position.update_attributes(:lat => m[:lat], :lng =>m[:lng], :ordering => m[:order])
                    # logger.debug "UPDATED TimeMarkersPosition "+String(position.lat)+"|"+String(position.lng)
                  # else
                    # logger.debug "ERROR TimeMarkersPosition "+String(position.lat)+"|"+String(position.lng)
                  # end
                # end
              # else
                if (position = marker.time_markers_position.create!(:lat => m[:lat], :lng =>m[:lng], :ordering => m[:order]))
                  logger.debug "CREATED TimeMarkersPosition "+String(position.lat)+"|"+String(position.lng)
                else
                  logger.debug "CREATE ERROR TimeMarkersPosition "+String(position.lat)+"|"+String(position.lng)
                end
              # end
            end
          end
        else
          if (marker = @info.time_markers_time.create!(:content => p[:content], :time =>p[:time]))
            logger.debug "CREATED TimeMarkerTime "+String(marker.time)
          else
            logger.debug "CREATED ERROR TimeMarkerTime "+String(marker.time)
          end
          for idx2 in 0...p[:position].length

            m = p[:position][String(idx2)]
            if (position = marker.time_markers_position.create!(:lat => m[:lat], :lng =>m[:lng], :ordering => m[:order]))
              logger.debug "CREATED TimeMarkersPosition "+String(position.lat)+"|"+String(position.lng)
            else
              logger.debug " CREATED ERROR TimeMarkersPosition "+String(position.lat)+"|"+String(position.lng)

            end
          end
        end
      end
       render json: {done: true}
    else
       render json: {done: false}
    end
  end

  def create
     @story = Story.find(params[:id])
     @res ={}
    if current_user? @story.user
      if(params[:type] == "point")
         
        if(item = @story.time_markers.create!(full_title: "Point - no name", content: "", color: "dedede", singleton: true ))
           time = item.time_markers_time.create!(time: params[:time])
           pos = time.time_markers_position.create!(lat: params[:lat],lng: params[:lng])
           @res = {done: true}
        end
      elsif(params[:type]=="line")
        
        if(item = @story.time_markers.create!(full_title: "Line - no name", content: "", color: "dedede", linear: true ))
           time = item.time_markers_time.create!(time: params[:time])
           pos = time.time_markers_position.create!(lat: params[:lat],lng: params[:lng], ordering: 1)
           pos = time.time_markers_position.create!(lat: Float(params[:lat])+0.1,lng: Float(params[:lng])+0.1, ordering: 2)
           @res = {done: true}
        end

      elsif(params[:type]=="polygon")
        
        if(item = @story.time_markers.create!(full_title: "Polygon - no name", content: "", color: "dedede", polygon: true ))
           time = item.time_markers_time.create!(time: params[:time])
           pos = time.time_markers_position.create!(lat: params[:lat],lng: params[:lng], ordering: 1)
           pos = time.time_markers_position.create!(lat: Float(params[:lat])+0.1,lng: params[:lng], ordering: 2)
           pos = time.time_markers_position.create!(lat: Float(params[:lat])+0.1,lng: Float(params[:lng])+0.1, ordering: 3)
           pos = time.time_markers_position.create!(lat: params[:lat],lng: Float(params[:lng])+0.1, ordering: 4)
           @res = {done: true}
        end    
      end
      
    else
       @res ={done: false}
    end
     render json: @res
  end

   private

  def permission_check
    timeStop = TimeMarker.find(params[:id])
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
