class AddSpecialsToTimeMarker < ActiveRecord::Migration
  def change
    add_column :time_markers, :singleton, :boolean
    add_column :time_markers, :linear, :boolean
    add_column :time_markers, :polygon, :boolean
  end
end
