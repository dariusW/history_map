class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.string :reference
      t.integer :reference_id
      t.text :content

      t.timestamps
    end
  end
end
