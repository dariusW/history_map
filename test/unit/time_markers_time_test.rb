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

require 'test_helper'

class TimeMarkersTimeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
