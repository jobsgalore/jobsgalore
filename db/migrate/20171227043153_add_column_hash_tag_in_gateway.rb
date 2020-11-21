class AddColumnHashTagInGateway < ActiveRecord::Migration[5.0]
  def up
    change_table :gateways do |t|
      t.string :hashtags
    end
  end
  def down
    remove_column :gateways , :hashtags
  end
end
