class AddValueToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :value, :integer, default: 0
  end
end
