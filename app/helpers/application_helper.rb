module ApplicationHelper

  #Returns full title
  def full_title(page_title)
    base_title = "Live History - interaktywne mapy historyczne"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end


end
