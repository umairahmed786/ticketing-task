class Attachment < ApplicationRecord
  acts_as_tenant :organization
end
