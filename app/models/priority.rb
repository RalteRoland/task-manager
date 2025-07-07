class Priority < ApplicationRecord
  has_many :tasks, dependent: :restrict_with_error
  default_scope { where(active: true) }

  validates :name, presence: true, uniqueness: true
end
