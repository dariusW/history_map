class CreateTimeStops < ActiveRecord::Migration
  def change
    create_table :time_stops do |t|
      t.references :Story
      t.string :name
      t.string :full_title
      t.integer :time

      t.timestamps
    end
    add_index :time_stops, :Story_id
  end
end
