class Comment < ApplicationRecord
  acts_as_tenant :organization
  has_many_attached :files, dependent: :destroy

  validates :content, presence: true, length: { minimum: 3 }

end
