require 'rails_helper'

feature 'Visit the users page', js: true do
  given!(:admin) { create(:admin_user) }
  given!(:person1) { create(:person) }
  given!(:person2) { create(:person) }
  given!(:conversation1) { create(:conversation, person: person1) }

  scenario 'see the conversation already created and send a message' do
    visit admin_api_people_path
    expect(page).to have_content('Send Message')

    within("#api_person_#{person1.id}") do
      find('a', text: 'Send Message').click
    end

    fill_in 'message', with: 'A new message'
    find('[name="message"]').native.send_keys(:return)

    visit admin_chat_path

    expect(page).not_to have_content('A new message')

    find('.active-admin-chat__conversation-item', text: person1.email).click

    expect(page).to have_content('A new message')
  end

  scenario 'create a conversation and send a message' do
    visit admin_api_people_path
    expect(Conversation.find_by(person_id: person2.id)).to be_nil
    expect(page).to have_content('Send Message')

    within("#api_person_#{person2.id}") do
      find('a', text: 'Send Message').click
    end
    expect(Conversation.find_by(person_id: person2.id)).not_to be_nil

    fill_in 'message', with: 'A new message'
    find('[name="message"]').native.send_keys(:return)

    visit admin_chat_path

    expect(page).not_to have_content('A new message')

    find('.active-admin-chat__conversation-item', text: person2.email).click

    expect(page).to have_content('A new message')
  end
end
