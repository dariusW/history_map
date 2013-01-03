class AddBlockedToStory < ActiveRecord::Migration
  def change
    add_column :stories, :blocked, :boolean
  end
end
