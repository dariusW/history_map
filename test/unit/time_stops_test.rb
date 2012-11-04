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

require 'test_helper'

class TimeStopsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
