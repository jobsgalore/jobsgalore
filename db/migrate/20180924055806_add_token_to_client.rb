class AddTokenToClient < ActiveRecord::Migration[5.2]
  def change
    change_table :clients do |elem|
      elem.string :token
    end
  end
end
