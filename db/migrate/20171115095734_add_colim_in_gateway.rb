class AddColimInGateway < ActiveRecord::Migration[5.0]
  def up
    change_table :gateways do |t|
      t.string :log
    end
  end
  def down
    remove_column :gateways , :log
  end
end
