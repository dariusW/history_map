class AddOrderToTimeMarkersPosition < ActiveRecord::Migration
  def change
    add_column :time_markers_positions, :ordering, :integer
  end
end
