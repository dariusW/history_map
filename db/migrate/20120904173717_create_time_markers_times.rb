class CreateTimeMarkersTimes < ActiveRecord::Migration
  def change
    create_table :time_markers_times do |t|
      t.references :TimeMarker
      t.string :name
      t.integer :time
      t.double :latitude
      t.double :longitude

      t.timestamps
    end
    add_index :time_markers_times, :TimeMarker_id
  end
end
