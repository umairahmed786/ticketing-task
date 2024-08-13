class Organization < ApplicationRecord
  has_many :users
  has_many :projects
  has_many :project_users
  validates :name, :subdomain, presence: true, uniqueness: true
  validates :subdomain, format: {
    with: /\A(?=.*[a-zA-Z])[a-zA-Z0-9]+\z/,
    message: 'must only contain alphabets and numbers, and must include at least one alphabet.'
  }
end
