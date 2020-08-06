class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :sender
      t.string :text
      t.references :room

      t.integer :super_chat_type, default: 0

      t.timestamps
    end
  end
end
