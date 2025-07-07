class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :task

  validates :content, presence: true

  # ✅ Add these two helper methods
  def author_name
    user&.name || 'Unknown'
  end

  def time_ago
    ActionController::Base.helpers.time_ago_in_words(created_at) + ' ago'
  end
end
