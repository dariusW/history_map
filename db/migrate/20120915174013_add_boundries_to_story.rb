class AddBoundriesToStory < ActiveRecord::Migration
  def change
    add_column :stories, :bottom_boundry, :integer
    add_column :stories, :top_boundry, :integer
  end
end
