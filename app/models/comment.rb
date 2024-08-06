class Comment < ApplicationRecord
  acts_as_tenant :organization
end
