class Organization < ApplicationRecord
  has_many :users
  has_many :projects
  has_many :project_users
  validates :name, :subdomain, presence: true, uniqueness: true
end
