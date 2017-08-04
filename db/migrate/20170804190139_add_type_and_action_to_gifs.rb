class AddTypeAndActionToGifs < ActiveRecord::Migration[5.1]
  def change
    add_column :gifs, :github_type, :string
    add_column :gifs, :activate, :string
    add_index :gifs, :github_type
  end
end
