# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: ""
      t.string :name
      t.string :phone
      t.datetime :birthday
      t.string :avatar
      t.string :password_digest
      t.string :remember_digest
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
  end
end
