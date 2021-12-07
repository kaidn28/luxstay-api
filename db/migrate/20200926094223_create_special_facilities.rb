class CreateSpecialFacilities < ActiveRecord::Migration[6.0]
  def change
    create_table :special_facilities do |t|
      t.boolean :balcony
      t.boolean :karaoke
      t.boolean :bbq_space
      t.boolean :swimming_pool
    end
  end
end
