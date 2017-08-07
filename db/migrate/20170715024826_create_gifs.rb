class CreateGifs < ActiveRecord::Migration[5.1]
  def change
    create_table :gifs do |t|
      t.integer :user_id
      t.string :keyword
      t.string :url

      t.timestamps
    end

    add_index :gifs, :user_id
    add_index :gifs, :keyword
  end
end
