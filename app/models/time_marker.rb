# == Schema Information
#
# Table name: time_markers
#
#  id         :integer          not null, primary key
#  story_id   :integer
#  name       :string(255)
#  full_title :string(255)
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  color      :string(255)
#

class TimeMarker < ActiveRecord::Base
  belongs_to :story
  has_many :time_markers_time
  attr_accessible :full_title, :name, :content, :color
  
  validates :story_id, presence: true
  validates :full_title, presence: true
  validates :name, presence: true
end
