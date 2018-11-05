class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.integer :person_id

      t.timestamps
    end
    add_index :conversations, :person_id
  end
end
