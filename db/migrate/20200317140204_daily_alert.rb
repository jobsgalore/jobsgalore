class DailyAlert < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :alert, :boolean, default: true, null: false
  end
end
