class CreateTimeStops < ActiveRecord::Migration
  def change
    create_table :time_stops do |t|
      t.references :story
      t.string :name
      t.string :full_title
      t.integer :time
      t.text :content

      t.timestamps
    end
    add_index :time_stops, :story_id
  end
end
