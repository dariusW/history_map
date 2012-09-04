class Story < ActiveRecord::Base
  belongs_to :User
  attr_accessible :full_title, :name, :precision, :published
end
