class CreateLocation < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.text :district
      t.text :town
      t.text :road
      t.text :home_number
    end
  end
end
