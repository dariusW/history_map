class DefaultBlockedToStory < ActiveRecord::Migration
  def change
    change_column :stories, :blocked, :boolean, :default => 0
  end
end
