class Comment < ApplicationRecord
  acts_as_tenant :organization
  validates :content, presence: true, length: { minimum: 10 }

end
