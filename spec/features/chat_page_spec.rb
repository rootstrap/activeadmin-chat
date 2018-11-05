require 'rails_helper'
require 'factories/conversation'
require 'factories/person'

feature 'Visit the chat page' do
  scenario 'has the customized content' do
    person1 = create(:person)
    person2 = create(:person)
    create(:conversation, person: person1)
    create(:conversation, person: person2)

    visit admin_chat_path

    expect(page).to have_content(person1.email)
    expect(page).to have_content(person2.email)
  end
end
