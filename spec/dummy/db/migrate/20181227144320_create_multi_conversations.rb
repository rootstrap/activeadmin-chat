class CreateMultiConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :multi_conversations do |t|
      t.integer :multi_person_id
      t.integer :admin_user_id

      t.timestamps
    end
    add_index :multi_conversations, :multi_person_id
    add_index :multi_conversations, :admin_user_id
  end
end
