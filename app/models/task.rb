class Task < ApplicationRecord
  belongs_to :assignee, class_name: 'User', optional: true

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w[in_progress done] }  # Removed 'pending'
  validates :due_date, presence: true

  def assignee_name
    assignee&.name || "Unassigned"
  end

  def display_status
    if status != 'done' && due_date < Date.today
      'overdue'
    else
      status
    end
  end

  def overdue?
    status != 'done' && due_date < Date.today
  end
end
