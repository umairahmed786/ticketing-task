class FieldChange < ApplicationRecord
  acts_as_tenant :organization
end
