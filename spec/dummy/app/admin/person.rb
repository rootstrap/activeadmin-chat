ActiveAdmin.register Api::Person do
  permit_params :email
  index do
    column :email
    actions do |person|
      send_message_link person
    end
  end
end
