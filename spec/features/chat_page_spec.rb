require 'rails_helper'
require 'factories/conversation'
require 'factories/person'
require 'factories/text'

feature 'Visit the chat page', js: true do
  scenario 'has the customized content' do
    person1 = build(:person)
    person2 = build(:person)
    text1 = build(:text, content: 'Person 1 chat content', sender: person1)
    text2 = build(:text, content: 'Person 2 first chat content', sender: person2)
    text3 = build(:text, content: 'Person 2 second chat content', sender: person2)
    create(:conversation, person: person1, texts: [text1])
    create(:conversation, person: person2, texts: [text2, text3])

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
end
