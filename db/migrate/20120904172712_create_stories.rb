class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.references :user
      t.string :name
      t.string :full_title
      t.string :precision
      t.boolean :published
      t.text :content

      t.timestamps
    end
    add_index :stories, :user_id
  end
end
