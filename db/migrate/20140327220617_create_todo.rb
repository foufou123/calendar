class CreateTodo < ActiveRecord::Migration
  def change
      drop_table :to_dos
      create_table :todos do |t|
      t.column :task, :string
      t.column :user_id, :integer


      t.timestamps
    end
  end
end
