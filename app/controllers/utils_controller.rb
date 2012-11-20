class UtilsController < ApplicationController
  def date
    @id = ""
    @date = 0
    @res = {}
    if(!params[:id].nil? && !params[:date].nil?)
      @id = params[:id]
      @date = Integer(params[:date])
    else
      @res ={error: "no data", id: @id}
    end

    if(@id.length>0 && @date.abs>=100000000)
      if(!validateDate(parseDate(@date)))
        @res = {error: "invalid date", id: @id}
      else
        @res[:date] = parseDate(@date)
        @res[:id] = @id
      end
    else
      @res ={error: "data to short", id: @id}
    end

    logger.debug @res
    render json: @res
  end
end
