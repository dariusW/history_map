class TimeStops < ActiveRecord::Base
  belongs_to :Story
  attr_accessible :full_title, :name
end
