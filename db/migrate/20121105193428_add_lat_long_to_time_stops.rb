class AddLatLongToTimeStops < ActiveRecord::Migration
  def change
    add_column :time_stops, :lat, :float
    add_column :time_stops, :long, :float
  end
end
