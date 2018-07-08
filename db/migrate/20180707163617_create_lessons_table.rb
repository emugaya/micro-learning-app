class CreateLessonsTable < ActiveRecord::Migration[5.2]
  def up
    create_table :lessons do |t|
      t.string :name
      t.string :description
      t.string :url
      t.belongs_to :course, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :courses
  end
end
