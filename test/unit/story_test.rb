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

require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
