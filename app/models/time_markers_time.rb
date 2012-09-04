class TimeMarkersTime < ActiveRecord::Base
  belongs_to :TimeMarker
  attr_accessible :name, :time
end
