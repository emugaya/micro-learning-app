class CreateEnrollmentTable < ActiveRecord::Migration[5.2]
  def up
    create_table :enrollments do |t|
      t.belongs_to :course, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.string :status
      t.integer :'next_lesson'
      t.datetime :next_sending_time

      t.timestamps
    end
  end

  def down
    drop_table :enrollments
  end
end
