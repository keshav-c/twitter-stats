class CreateReportsAndFollowers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :reports, :followers do |t|
      t.index :report_id
      t.index :follower_id
    end
  end
end
