class CreateCoursesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.belongs_to :category, index: true

      t.timestamps
    end
  end

  def down
    drop_table :courses
  end
end
