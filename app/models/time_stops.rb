# == Schema Information
#
# Table name: time_stops
#
#  id         :integer          not null, primary key
#  story_id   :integer
#  name       :string(255)
#  full_title :string(255)
#  time       :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TimeStops < ActiveRecord::Base
  belongs_to :story
  attr_accessible :full_title, :name, :content, :time
  
  validates :story_id, presence: true
  validates :full_title, presence: true
  validates :time, presence: true
  validates :name, presence: true
end
