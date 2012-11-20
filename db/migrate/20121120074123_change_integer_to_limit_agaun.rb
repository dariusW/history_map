class ChangeIntegerToLimitAgaun < ActiveRecord::Migration
  def change
    change_column :time_stops, :time, :bigint
    change_column :stories, :bottom_boundry, :bigint
    change_column :stories, :top_boundry, :bigint
    change_column :time_maps_times, :time, :bigint
    change_column :time_markers_times, :time, :bigint
  end
end
