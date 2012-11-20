class CreateTimeMapsTimes < ActiveRecord::Migration
  def change
    create_table :time_maps_times do |t|
      t.references :time_map
      t.string :name
      t.integer :time, :limit => 8
      t.float :latitude
      t.float :longitude
      t.string :map
      t.text :content

      t.timestamps
    end
    add_index :time_maps_times, :time_map_id
  end
end
