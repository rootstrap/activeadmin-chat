class CreateApiPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :api_people do |t|
      t.string :email

      t.timestamps
    end
  end
end
