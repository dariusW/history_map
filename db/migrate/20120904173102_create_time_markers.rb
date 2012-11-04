class CreateTimeMarkers < ActiveRecord::Migration
  def change
    create_table :time_markers do |t|
      t.references :story
      t.string :name
      t.string :full_title
      t.text :content

      t.timestamps
    end
    add_index :time_markers, :story_id
  end
end
