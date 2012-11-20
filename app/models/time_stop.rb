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

class TimeStop < ActiveRecord::Base
  belongs_to :story
  attr_accessible :full_title, :name, :content, :time, :lat, :long
  
  validates :story_id, presence: true
  validates :full_title, presence: true
  validates :time, presence: true
  validates :lat, presence: true, numericality: { greater_than_or_equal_to:  -90 , less_than_or_equal_to: 90 }
  validates :long, presence: true , numericality: { greater_than_or_equal_to:  -180 , less_than_or_equal_to: 180 }
end
