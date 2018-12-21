class CreateMultiTexts < ActiveRecord::Migration[5.2]
  def change
    create_table :multi_texts do |t|
      t.string :content
      t.references :sender, polymorphic: true
      t.integer :multi_conversation_id

      t.timestamps
    end
    add_index :multi_texts, :multi_conversation_id
  end
end
