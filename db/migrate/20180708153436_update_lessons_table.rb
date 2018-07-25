class UpdateLessonsTable < ActiveRecord::Migration[5.2]
  def change
    change_table :lessons do |t|
      t.belongs_to :day, index: true
    end
  end
end
