class Task < ApplicationRecord
  has_many_attached :attachments
  belongs_to :user  # Added this - needed for current_user.tasks
  belongs_to :assignee, class_name: 'User', optional: true

  validates :title, presence: true
  validates :description, presence: true  # Added this back since your form requires it
  validates :status, presence: true, inclusion: { in: %w[in_progress done] }
  validates :due_date, presence: true

  def assignee_name
    assignee&.name || assignee&.email  # Fixed the string literal bug
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
