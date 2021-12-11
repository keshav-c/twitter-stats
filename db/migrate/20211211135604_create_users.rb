class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :handle
      t.string :twitterid

      t.timestamps
    end
    add_index :users, :handle, unique: true
    add_index :users, :twitterid, unique: true
  end
end
