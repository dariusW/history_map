# == Schema Information
#
# Table name: time_maps_times
#
#  id          :integer          not null, primary key
#  time_map_id :integer
#  name        :string(255)
#  time        :integer
#  latitude    :float
#  longitude   :float
#  map         :string(255)
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TimeMapsTime < ActiveRecord::Base
  belongs_to :time_map
  attr_accessible :latitude, :longitude, :map, :name, :time, :content
  
  validates :time_map_id, presence: true
  # validates :latitude, presence: true
  # validates :longitude, presence: true
  validates :map, presence: true
  validates :name, presence: true
  validates :time, presence: true
end
