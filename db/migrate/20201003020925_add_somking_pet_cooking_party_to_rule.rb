class AddSomkingPetCookingPartyToRule < ActiveRecord::Migration[6.0]
  def change
    add_column :rules, :smoking, :integer
    add_column :rules, :pet, :integer
    add_column :rules, :cooking, :integer
    add_column :rules, :party, :integer
  end
end
