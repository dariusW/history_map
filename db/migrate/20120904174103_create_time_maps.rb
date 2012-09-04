class CreateTimeMaps < ActiveRecord::Migration
  def change
    create_table :time_maps do |t|
      t.references :Story
      t.string :name
      t.string :full_title

      t.timestamps
    end
    add_index :time_maps, :Story_id
  end
end
