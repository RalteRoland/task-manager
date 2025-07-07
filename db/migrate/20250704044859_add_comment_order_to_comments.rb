class AddCommentOrderToComments < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :comment_order, :integer
    add_index :comments, [:task_id, :comment_order], unique: true
  end
end
