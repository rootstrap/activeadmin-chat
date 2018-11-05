require 'factories/text'

FactoryBot.define do
  factory :conversation do
    after(:create) do |conversation|
      create_list(:text, 2, conversation: conversation, sender: conversation.person)
    end
  end
end
