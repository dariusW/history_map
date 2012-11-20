class TimeMarkersPosition < ActiveRecord::Base
  attr_accessible :lat, :lng, :ordering
  belongs_to :time_markers_time
  
  validates :time_markers_time_id, presence: true
  validates :lat, presence: true, numericality: { greater_than_or_equal_to:  -90 , less_than_or_equal_to: 90 }
  validates :lng, presence: true , numericality: { greater_than_or_equal_to:  -180 , less_than_or_equal_to: 180 }
end
