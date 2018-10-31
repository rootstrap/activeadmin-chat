require 'rails_helper'
require 'factories/admin_user'
require 'factories/conversation'
require 'factories/person'
require 'factories/text'

feature 'Visit the chat page', js: true do
  given!(:admin) { create(:admin_user) }
  given(:person1) { create(:person) }
  given(:person2) { create(:person) }

  scenario 'see the chat history' do
    conversation1 = create(:conversation, person: person1)
    conversation2 = create(:conversation, person: person2)
    create(:text, sender: person1, conversation: conversation1, content: 'Person1 Content1.')
    create(:text, sender: person2, conversation: conversation2, content: 'Person2 Content1.')
    create(:text, sender: person2, conversation: conversation2, content: 'Person2 Content2.')

    visit admin_chat_path

    expect(page).to have_content(person1.email)
    expect(page).to have_content(person2.email)

    find('.active-admin-chat__conversation-item', text: person1.email).click

    expect(page).to have_content('Person1 Content1.')
    expect(page).not_to have_content('Person2 Content1.')
    expect(page).not_to have_content('Person2 Content2.')

    find('.active-admin-chat__conversation-item', text: person2.email).click

    expect(page).not_to have_content('Person1 Content1.')
    expect(page).to have_content('Person2 Content1.')
    expect(page).to have_content('Person2 Content2.')
  end

  scenario 'sends a message' do
    create(:conversation, :with_texts, text_count: 1, person: person1)

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
  end

  scenario 'scrolling loads more messages' do
    create(:conversation, :with_texts, text_count: 60, person: person1)

    visit admin_chat_path

    find('.active-admin-chat__conversation-item', text: person1.email).click

    expect(page).to have_selector('.active-admin-chat__message-container', count: 25)

    within '.active-admin-chat__conversation-history' do
      top_message = page.find('.active-admin-chat__message-container', match: :first)
      page.execute_script 'arguments[0].scrollIntoView(true)', top_message
    end

    expect(page).to have_selector('.active-admin-chat__message-container', count: 50)

    within '.active-admin-chat__conversation-history' do
      top_message = page.find('.active-admin-chat__message-container', match: :first)
      page.execute_script 'arguments[0].scrollIntoView(true)', top_message
    end

    expect(page).to have_selector('.active-admin-chat__message-container', count: 60)
  end

  scenario "doesn't repeat messages when retrieving duplicates because of pagination" do
    create(:conversation, :with_texts, text_count: 30, person: person1)

    visit admin_chat_path

    find('.active-admin-chat__conversation-item', text: person1.email).click

    within '.active-admin-chat__conversation-history' do
      expect(page).to have_selector('.active-admin-chat__message-container', count: 25)
    end

    fill_in 'send-message', with: 'A new message'
    find('#send-message').native.send_keys(:return)

    expect(page).to have_content('A new message')
    expect(page).to have_selector('.active-admin-chat__message-container', count: 26)

    within '.active-admin-chat__conversation-history' do
      top_message = page.find('.active-admin-chat__message-container', match: :first)
      page.execute_script 'arguments[0].scrollIntoView(true)', top_message
    end

    expect(page).to have_selector('.active-admin-chat__message-container', count: 31)
  end
end
