class AddEnableReportingToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :enable_report, :boolean, default: true
  end
end
