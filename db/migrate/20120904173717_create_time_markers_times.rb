class CreateTimeMarkersTimes < ActiveRecord::Migration
  def change
    create_table :time_markers_times do |t|
      t.references :time_marker
      t.string :name
      t.integer :time
      t.float :latitude
      t.float :longitude
      t.text :content

      t.timestamps
    end
    add_index :time_markers_times, :time_marker_id
  end
end
