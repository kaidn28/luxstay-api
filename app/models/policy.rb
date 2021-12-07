class Policy < ApplicationRecord
  belongs_to :place, inverse_of: :policy
  validates :place, presence: true

  enum currency: {vnd: 1, usd: 2, yen: 3}
  enum cancel_policy: {normal: 1, flexible: 2, strict: 3}

  validates :currency, presence: true, inclusion: {in: currencies.keys}
  validates :cancel_policy, presence: true, inclusion: {in: cancel_policies.keys}
  validates :max_num_of_people, presence: true,
    numericality: {only_integer: true,
                   greater_than_or_equal_to: Settings.validations.place.min_people}
end
