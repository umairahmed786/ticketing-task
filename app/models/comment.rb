class Comment < ApplicationRecord
  acts_as_tenant :organization
  has_many_attached :files, dependent: :destroy

  validates :content, presence: true 
  validates :content, length: { minimum: 3 }, if: -> { content.present? }

end
