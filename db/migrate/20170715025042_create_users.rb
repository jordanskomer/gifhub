class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :login
      t.integer :github_id
      t.string :avatar
      t.string :profile_url
      t.string :email
      t.integer :installation_id

      t.timestamps
    end

    add_index :users, :installation_id
    add_index :users, :login
    add_index :users, :github_id
    add_index :users, :email
  end
end
