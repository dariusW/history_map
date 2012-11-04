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

require 'test_helper'

class TimeMarkerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
