class CreateRule < ActiveRecord::Migration[6.0]
  def change
    create_table :rules do |t|
      t.text :special_rules
    end
  end
end
