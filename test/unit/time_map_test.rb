# == Schema Information
#
# Table name: time_maps
#
#  id         :integer          not null, primary key
#  story_id   :integer
#  name       :string(255)
#  full_title :string(255)
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TimeMapTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
