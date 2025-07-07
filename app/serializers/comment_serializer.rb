class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :comment_order, :author_name, :created_at, :time_ago

  def author_name
    object.user&.name || 'Unknown'
  end

  def time_ago
    ActionController::Base.helpers.time_ago_in_words(object.created_at) + ' ago'
  end
end
