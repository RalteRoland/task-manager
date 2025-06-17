class Task < ApplicationRecord
  belongs_to :assignee, class_name: 'User', optional: true

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending in_progress done] }
  validates :due_date, presence: true

  def assignee_name
    assignee&.name || "Unassigned"
  end
end
