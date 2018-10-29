class CreateTexts < ActiveRecord::Migration[5.2]
  def change
    create_table :texts do |t|
      t.string :content
      t.references :sender, polymorphic: true
      t.integer :conversation_id

      t.timestamps
    end
    add_index :texts, :conversation_id
  end
end
