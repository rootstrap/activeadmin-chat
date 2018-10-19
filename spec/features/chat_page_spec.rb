require 'rails_helper'

feature 'Visit the chat page' do
  scenario 'has the customized content' do
    visit admin_chat_path

    expect(page).to have_content('This is the chat')
  end
end
