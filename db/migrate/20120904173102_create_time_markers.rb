class CreateTimeMarkers < ActiveRecord::Migration
  def change
    create_table :time_markers do |t|
      t.references :Story
      t.string :name
      t.string :full_title

      t.timestamps
    end
    add_index :time_markers, :Story_id
  end
end
