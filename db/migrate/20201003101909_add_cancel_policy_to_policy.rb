class AddCancelPolicyToPolicy < ActiveRecord::Migration[6.0]
  def change
    add_column :policies, :cancel_policy, :integer
  end
end
