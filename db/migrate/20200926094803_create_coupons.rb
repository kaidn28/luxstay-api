class CreateCoupons < ActiveRecord::Migration[6.0]
  def change
    create_table :coupons do |t|
      t.string :code_name
      t.datetime :start_date
      t.datetime :expire_date
    end
  end
end
