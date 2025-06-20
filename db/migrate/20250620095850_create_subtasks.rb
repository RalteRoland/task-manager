class CreateSubtasks < ActiveRecord::Migration[8.0]
  def change
    create_table :subtasks do |t|
      t.string :title
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
