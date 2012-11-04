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

require 'test_helper'

class TimeMapsTimeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
