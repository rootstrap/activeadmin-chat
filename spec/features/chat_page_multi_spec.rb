require 'rails_helper'
require 'timecop'
require 'factories/admin_user'
require 'factories/multi_conversation'
require 'factories/multi_person'
require 'factories/multi_text'

feature 'Multi: Visit the chat page', js: true do
  given!(:admin) { create(:admin_user) }
  given(:person1) { create(:multi_person) }
  given(:person2) { create(:multi_person) }
  given(:person3) { create(:multi_person) }
  given(:text1) { build(:multi_text, content: 'Person 1 chat content', sender: person1) }
  given(:text2) { build(:multi_text, content: 'Person 2 first chat content', sender: person2) }
  given(:text3) { build(:multi_text, content: 'Person 2 second chat content', sender: person2) }
  given!(:conversation1) do
    create(:multi_conversation, multi_person: person1,
                                multi_texts: [text1], admin_user: admin)
  end
  given!(:conversation2) do
    create(:multi_conversation, multi_person: person2,
                                multi_texts: [text2, text3], admin_user: admin)
  end
  given!(:conversation3) { create(:multi_conversation, multi_person: person3, admin_user: admin) }

  before do
    @previous_user_model_name = ActiveAdminChat.application.user_model_name
    @previous_conversation_model_name = ActiveAdminChat.application.conversation_model_name
    @previous_message_model_name = ActiveAdminChat.application.message_model_name
    ActiveAdminChat.application.user_model_name = 'api/multi_person'
    ActiveAdminChat.application.conversation_model_name = 'multi_conversation'
    ActiveAdminChat.application.message_model_name = 'multi_text'
  end

  after do
    ActiveAdminChat.application.user_model_name = @previous_user_model_name
    ActiveAdminChat.application.conversation_model_name = @previous_conversation_model_name
    ActiveAdminChat.application.message_model_name = @previous_message_model_name
  end

  scenario 'see the chat history', multi: true do
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

  scenario 'sends a message', multi: true do
    Timecop.freeze(Time.current) do
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

  scenario "sends a message and 'No messages' disappear", multi: true do
    Timecop.freeze(Time.current) do
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
  given(:person1) { create(:multi_person) }
  given(:texts1) do
    build_list(:multi_text, 5, content: 'Person 1 oldest chat messages', sender: person1,
                               created_at: (Time.current - 10.minutes))
  end
  given(:texts2) do
    build_list(:multi_text, 25, content: 'Person 1 older chat messages', sender: person1,
                                created_at: Time.current - 5.minutes)
  end
  given(:texts3) do
    build_list(:multi_text, 25, content: 'Person 1 newest chat messages', sender: person1,
                                created_at: Time.current)
  end
  given!(:conversation1) do
    create(:multi_conversation, multi_person: person1,
                                multi_texts: texts1 + texts2 + texts3, admin_user: admin)
  end

  before do
    @previous_user_model_name = ActiveAdminChat.application.user_model_name
    @previous_conversation_model_name = ActiveAdminChat.application.conversation_model_name
    @previous_message_model_name = ActiveAdminChat.application.message_model_name
    ActiveAdminChat.application.user_model_name = 'api/multi_person'
    ActiveAdminChat.application.conversation_model_name = 'multi_conversation'
    ActiveAdminChat.application.message_model_name = 'multi_text'
  end

  after do
    ActiveAdminChat.application.user_model_name = @previous_user_model_name
    ActiveAdminChat.application.conversation_model_name = @previous_conversation_model_name
    ActiveAdminChat.application.message_model_name = @previous_message_model_name
  end

  scenario 'see the chat history', multi: true do
    visit admin_chat_path

    expect(conversation1.multi_texts.count).to eq(55)
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
