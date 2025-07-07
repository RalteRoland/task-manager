class Role < ApplicationRecord
  has_many :users
  default_scope { where(active: true) }
end
