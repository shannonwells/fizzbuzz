class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :phone_number
      t.integer :delay_minutes
      t.integer :fizzbuzz_number
      t.timestamps
    end
  end
end
