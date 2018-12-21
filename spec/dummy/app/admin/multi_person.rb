ActiveAdmin.register Api::MultiPerson do
  permit_params :email
  index do
    column :email
    actions do |multi_person|
      send_message_link multi_person
    end
  end
end
