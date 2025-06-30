class CreatePriorities < ActiveRecord::Migration[7.1]
  def change
    create_table :priorities do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :priorities, :name, unique: true
  end
end
