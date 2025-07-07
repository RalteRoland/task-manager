class Task < ApplicationRecord
  has_many_attached :attachments
  has_many :subtasks, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :subtasks, allow_destroy: true
  accepts_nested_attributes_for :comments, allow_destroy: true

  belongs_to :user
  belongs_to :priority
  belongs_to :status
  belongs_to :assignee, class_name: 'User', optional: true

  before_create :set_default_status
  after_initialize :set_default_status, if: :new_record?

  validates :title, :description, :due_date, :priority, presence: true

  validates :status, presence: true

  def set_default_status
    self.status ||= Status.find_by(name: 'open')
  end

  def mark_in_progress_if_open!
    update(status: Status.find_by(name: 'in_progress')) if status.name == 'open'
  end

  def assignee_name
    assignee&.name || assignee&.email
  end

  def display_status
    if status&.name != 'done' && due_date.present? && due_date < Date.today
      'overdue'
    else
      status&.name || 'unknown'
    end
  end

  def overdue?
    status.name != 'done' && due_date.present? && due_date < Date.today
  end
end
