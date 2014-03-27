class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column :description, :string
      t.column :location, :string
      t.column :start_date, :datetime
      t.column :end_date, :datetime

      t.timestamps
    end
  end
end
