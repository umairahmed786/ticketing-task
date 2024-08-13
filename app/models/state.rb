class State < ApplicationRecord
  acts_as_tenant :organization
  belongs_to :organization, optional: true
  has_one :transition, dependent: :destroy, foreign_key: :to_state_id
  # has_many :from_transitions, class_name: 'FromTransition', dependent: :destroy

  validates :name, presence: true
end
