class CreateUsersAndFollowers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :followers do |t|
      t.index :user_id
      t.index :follower_id
    end
  end
end
