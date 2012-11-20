class ChangeIntegerToLimit < ActiveRecord::Migration
  def change
    change_column :time_stops, :time, :integer, :limit => 8
    change_column :stories, :bottom_boundry, :integer, :limit => 8
    change_column :stories, :top_boundry, :integer, :limit => 8
    change_column :time_maps_times, :time, :integer, :limit => 8
    change_column :time_markers_times, :time, :integer, :limit => 8
  end
end
