require 'factories/person'
require 'factories/text'

FactoryBot.define do
  factory :conversation do
    person

    transient do
      text_count { 1 }
    end

    trait :with_texts do
      after(:create) do |instance, evaluator|
        create_list :text, evaluator.text_count, sender: instance.person, conversation: instance
      end
    end
  end
end
