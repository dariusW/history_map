# == Schema Information
#
# Table name: time_markers_times
#
#  id             :integer          not null, primary key
#  time_marker_id :integer
#  name           :string(255)
#  time           :integer
#  latitude       :float
#  longitude      :float
#  content        :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class TimeMarkersTime < ActiveRecord::Base
  belongs_to :time_marker
  attr_accessible :name, :time, :latitude, :longitude, :content
  attr_writer :last, :first, :full_time

  validates :time_marker_id, presence: true
  validates :name, presence: true 
  # validates :time, presence: true, numericality: { greater_than_or_equal_to:  (time_marker.bottom_boundry), less_than_or_equal_to: (time_marker.top_boundry) }
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to:  -90 , less_than_or_equal_to: 90 }
  validates :longitude, presence: true , numericality: { greater_than_or_equal_to:  -180 , less_than_or_equal_to: 180 }
end
