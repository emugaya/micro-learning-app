class CreateDaysTable < ActiveRecord::Migration[5.2]
  def up
    create_table :days do |t|
      t.string :name

      t.timestamps
    end
  end

  def down
    drop_table :days
  end
end
