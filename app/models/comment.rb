class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :task

  validates :content, presence: true
end
