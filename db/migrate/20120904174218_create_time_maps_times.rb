class CreateTimeMapsTimes < ActiveRecord::Migration
  def change
    create_table :time_maps_times do |t|
      t.references :TimeMap
      t.string :name
      t.integer :time
      t.double :latitude
      t.double :longitude
      t.string :map

      t.timestamps
    end
    add_index :time_maps_times, :TimeMap_id
  end
end
