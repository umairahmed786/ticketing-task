class Transition < ApplicationRecord
  acts_as_tenant :organization
  belongs_to :state, foreign_key: :to_state_id
  has_many :from_transitions, dependent: :destroy

  validates :event_name, presence: true
  validates :notify, inclusion: { in: [true, false] }
end
