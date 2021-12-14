class RemoveIndexFromReports < ActiveRecord::Migration[6.1]
  def change
    remove_index :reports, [:user_id, :date]
  end
end
