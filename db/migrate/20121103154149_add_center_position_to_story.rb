class AddCenterPositionToStory < ActiveRecord::Migration
  def change
    add_column :stories, :lat, :float
    add_column :stories, :long, :float
  end
end
