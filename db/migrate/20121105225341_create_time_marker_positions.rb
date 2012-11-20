class CreateTimeMarkerPositions < ActiveRecord::Migration
  def change
    create_table :time_markers_positions do |t|
      t.references :time_markers_time
      t.float :lat
      t.float :lng

      t.timestamps
    end
    add_index :time_markers_positions, :time_markers_time_id
  end
end
