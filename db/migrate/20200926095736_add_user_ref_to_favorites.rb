class AddUserRefToFavorites < ActiveRecord::Migration[6.0]
  def change
    add_reference :favorites, :user, null: false, foreign_key: true
  end
end
