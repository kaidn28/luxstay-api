class CreatePolicy < ActiveRecord::Migration[6.0]
  def change
    create_table :policies do |t|
      t.integer :currency
      t.integer :max_num_of_people
    end
  end
end
