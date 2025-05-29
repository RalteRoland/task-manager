class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending in_progress done] }
  validates :due_date, presence: true
end
