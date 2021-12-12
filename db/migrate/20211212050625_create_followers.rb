class CreateFollowers < ActiveRecord::Migration[6.1]
  def change
    create_table :followers do |t|
      t.string :twitterid
      t.string :handle

      t.timestamps
    end
    add_index :followers, :twitterid, unique: true
    add_index :followers, :handle, unique: true
  end
end
