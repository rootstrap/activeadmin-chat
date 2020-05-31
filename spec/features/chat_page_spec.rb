require 'rails_helper'

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
    freeze_time do
      visit admin_chat_path

      find('.active-admin-chat__conversation-item', text: person1.email).click

      expect(page).not_to have_content('A new message')

      fill_in 'send-message', with: 'A new message'
      find('#send-message').native.send_keys(:return)

      expect(page).to have_content('A new message')
      expect(page).to have_content(Time.current.strftime(':%M - %m/%d/%Y')
                                       .sub(%r{(0)?(\d)\/0(\d)}, '\2/\3'))

      visit admin_chat_path

      expect(page).not_to have_content('A new message')

      find('.active-admin-chat__conversation-item', text: person1.email).click

      expect(page).to have_content('A new message')
      expect(page).not_to have_content('No messages')
    end
  end

  scenario "sends a message and 'No messages' disappear" do
    freeze_time do
      visit admin_chat_path

      find('.active-admin-chat__conversation-item', text: person3.email).click

      expect(page).to have_content('No messages')

      expect(page).not_to have_content('A new message')

      fill_in 'send-message', with: 'A new message'
      find('#send-message').native.send_keys(:return)

      expect(page).to have_content('A new message')
      expect(page).to have_content(Time.current.strftime(':%M - %m/%d/%Y')
                                       .sub(%r{(0)?(\d)\/0(\d)}, '\2/\3'))

      visit admin_chat_path

      expect(page).not_to have_content('A new message')

      find('.active-admin-chat__conversation-item', text: person3.email).click

      expect(page).to have_content('A new message')
      expect(page).not_to have_content('No messages')
    end
  end
end

feature 'Visit the chat page and use the pagination', js: true do
  given!(:admin) { create(:admin_user) }
  given(:person1) { create(:person) }
  given(:texts1) do
    build_list(:text, 5, content: 'Person 1 oldest chat messages', sender: person1,
                         created_at: (Time.current - 10.minutes))
  end
  given(:texts2) do
    build_list(:text, 25, content: 'Person 1 older chat messages', sender: person1,
                          created_at: Time.current - 5.minutes)
  end
  given(:texts3) do
    build_list(:text, 25, content: 'Person 1 newest chat messages', sender: person1,
                          created_at: Time.current)
  end
  given!(:conversation1) { create(:conversation, person: person1, texts: texts1 + texts2 + texts3) }

  scenario 'see the chat history' do
    visit admin_chat_path

    expect(conversation1.texts.count).to eq(55)
    expect(page).to have_content(person1.email)

    find('.active-admin-chat__conversation-item', text: person1.email).click

    expect(page).to have_selector('.active-admin-chat__message-container', count: 25)
    expect(page).to have_content('Person 1 newest chat messages')
    expect(page).not_to have_content('Person 1 older chat messages')
    expect(page).not_to have_content('Person 1 oldest chat messages')

    within '.active-admin-chat__conversation-history' do
      top_message = page.find('.active-admin-chat__message-container', match: :first)
      page.execute_script 'arguments[0].scrollIntoView(true)', top_message
    end

    expect(page).to have_selector('.active-admin-chat__message-container', count: 50)
    expect(page).to have_content('Person 1 newest chat messages')
    expect(page).to have_content('Person 1 older chat messages')
    expect(page).not_to have_content('Person 1 oldest chat messages')

    within '.active-admin-chat__conversation-history' do
      top_message = page.find('.active-admin-chat__message-container', match: :first)
      page.execute_script 'arguments[0].scrollIntoView(true)', top_message
    end

    expect(page).to have_selector('.active-admin-chat__message-container', count: 55, wait: 3)
    expect(page).to have_content('Person 1 newest chat messages')
    expect(page).to have_content('Person 1 older chat messages')
    expect(page).to have_content('Person 1 oldest chat messages')
  end
end
