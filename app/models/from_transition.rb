class FromTransition < ApplicationRecord
  acts_as_tenant :organization
  belongs_to :transition
  belongs_to :state

  validates :transition_id, uniqueness: { scope: :state_id }
end
