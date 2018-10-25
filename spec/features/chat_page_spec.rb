require 'rails_helper'
require 'factories/admin_user'
require 'factories/conversation'
require 'factories/person'
require 'factories/text'

feature 'Visit the chat page', js: true do
  given!(:admin) { create(:admin_user) }
  given(:person1) { create(:person) }
  given(:person2) { create(:person) }
  given(:person3) { create(:person) }
  given(:text1) { build(:text, content: 'Person 1 chat content', sender: person1) }
  given(:text2) { build(:text, content: 'Person 2 first chat content', sender: person2) }
  given(:text3) { build(:text, content: 'Person 2 second chat content', sender: person2) }
  given!(:conversation1) { create(:conversation, person: person1, texts: [text1]) }
  given!(:conversation2) { create(:conversation, person: person2, texts: [text2, text3]) }
  given!(:conversation3) { create(:conversation, person: person3) }

  scenario 'see the chat history' do
    visit admin_chat_path

    expect(page).to have_content(person1.email)
    expect(page).to have_content(person2.email)

    find('.active-admin-chat__conversation-item', text: person1.email).click
    expect(page).to have_content('Person 1 chat content')
    expect(page).not_to have_content('Person 2 first chat content')
    expect(page).not_to have_content('Person 2 second chat content')

    find('.active-admin-chat__conversation-item', text: person2.email).click
    expect(page).not_to have_content('Person 1 chat content')
    expect(page).to have_content('Person 2 first chat content')
    expect(page).to have_content('Person 2 second chat content')
  end

  scenario 'sends a message' do
    visit admin_chat_path

    find('.active-admin-chat__conversation-item', text: person1.email).click

    expect(page).not_to have_content('A new message')

    fill_in 'send-message', with: 'A new message'
    find('#send-message').native.send_keys(:return)

    expect(page).to have_content('A new message')

    visit admin_chat_path

    expect(page).not_to have_content('A new message')

    find('.active-admin-chat__conversation-item', text: person1.email).click

    expect(page).to have_content('A new message')
    expect(page).not_to have_content('No messages')
  end

  scenario "sends a message and 'No messages' disappear" do
    visit admin_chat_path

    find('.active-admin-chat__conversation-item', text: person3.email).click

    expect(page).to have_content('No messages')

    expect(page).not_to have_content('A new message')

    fill_in 'send-message', with: 'A new message'
    find('#send-message').native.send_keys(:return)

    expect(page).to have_content('A new message')

    visit admin_chat_path

    expect(page).not_to have_content('A new message')

    find('.active-admin-chat__conversation-item', text: person3.email).click

    expect(page).to have_content('A new message')
    expect(page).not_to have_content('No messages')
  end
end
