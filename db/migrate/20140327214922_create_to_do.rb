class CreateToDo < ActiveRecord::Migration
  def change
    create_table :to_dos do |t|

      t.column :task, :string
      t.column :user_id, :integer


      t.timestamps
    end
  end
end
