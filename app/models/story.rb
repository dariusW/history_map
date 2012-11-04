# == Schema Information
#
# Table name: stories
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  name           :string(255)
#  full_title     :string(255)
#  precision      :string(255)
#  published      :boolean
#  content        :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  bottom_boundry :integer
#  top_boundry    :integer
#  lat            :float
#  long           :float
#

class Story < ActiveRecord::Base
  belongs_to :user
  attr_accessible :full_title, :name, :precision, :published, :content, :bottom_boundry, :top_boundry, :top_boundry_hash, :lat, :long
  
  validates :user_id, presence: true
  validates :name, presence: true
  validates :full_title, presence: true
  validates :precision, presence: true
  validates :bottom_boundry, presence: true
  validates :top_boundry, presence: true
  validates :lat, presence: true, numericality: { greater_than_or_equal_to:  -90 , less_than_or_equal_to: 90 }
  validates :long, presence: true , numericality: { greater_than_or_equal_to:  -180 , less_than_or_equal_to: 180 }
  
  has_many :time_maps, dependent: :destroy
  has_many :time_markers, dependent: :destroy
  has_many :time_stops, dependent: :destroy
end
