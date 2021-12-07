class Rule < ApplicationRecord
  belongs_to :place, inverse_of: :rule
  validates :place, presence: true

  enum smoking: {allowed: 1, unallowed: 2, charge: 3}, _prefix: true
  enum pet: {allowed: 1, unallowed: 2, charge: 3}, _prefix: true
  enum cooking: {allowed: 1, unallowed: 2, charge: 3}, _prefix: true
  enum party: {allowed: 1, unallowed: 2, charge: 3}, _prefix: true

  validates :special_rules, allow_nil: true,
                           length: {maximum: Settings.validations.place.max_length}
  validates :smoking, presence: true, inclusion: {in: smokings.keys}
  validates :pet, presence: true, inclusion: {in: pets.keys}
  validates :cooking, presence: true, inclusion: {in: cookings.keys}
  validates :party, presence: true, inclusion: {in: parties.keys}
end
