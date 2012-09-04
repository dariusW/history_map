class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.references :User
      t.string :name
      t.string :full_title
      t.string :precision
      t.boolean :published

      t.timestamps
    end
    add_index :stories, :User_id
  end
end
