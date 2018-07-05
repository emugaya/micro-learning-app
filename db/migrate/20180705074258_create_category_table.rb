class CreateCategoryTable < ActiveRecord::Migration[5.2]
  def up
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.belongs_to :user, index: { unique: true }, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :categories
  end
end
