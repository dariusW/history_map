class AddColorsToMarkers < ActiveRecord::Migration
  def change
    add_column :time_markers, :color, :string
  end
end
