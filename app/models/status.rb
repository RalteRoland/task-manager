class Status < ApplicationRecord
  has_many :tasks
  default_scope { where(active: true) }
end
