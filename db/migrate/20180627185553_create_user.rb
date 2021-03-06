class CreateUser < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :password_digest
      t.string :answer
      t.boolean :is_admin

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
