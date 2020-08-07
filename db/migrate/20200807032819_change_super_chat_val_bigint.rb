class ChangeSuperChatValBigint < ActiveRecord::Migration[6.0]
  def change
    change_column :messages, :value, :bigint
  end
end
