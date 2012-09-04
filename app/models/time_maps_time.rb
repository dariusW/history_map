class TimeMapsTime < ActiveRecord::Base
  belongs_to :TimeMap
  attr_accessible :latitude, :longitude, :map, :name, :time
end
