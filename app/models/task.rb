class Task < ApplicationRecord
  has_many_attached :attachments
  has_many :subtasks, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :subtasks, allow_destroy: true
  accepts_nested_attributes_for :comments, allow_destroy: true

  belongs_to :user
  belongs_to :assignee, class_name: 'User', optional: true

  VALID_PRIORITIES = %w[low medium high].freeze

  validates :priority, presence: true, inclusion: { in: VALID_PRIORITIES }

  VALID_STATUSES = %w[open in_progress done].freeze

  validates :title, :description, :due_date, presence: true
  validates :status, presence: true, inclusion: { in: VALID_STATUSES }

  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= 'open'
  end

  def mark_in_progress_if_open!
    update(status: 'in_progress') if status == 'open'
  end

  def assignee_name
    assignee&.name || assignee&.email
  end

  def display_status
    if status != 'done' && due_date.present? && due_date < Date.today
      'overdue'
    else
      status
    end
  end

  def overdue?
    status != 'done' && due_date.present? && due_date < Date.today
  end
end
