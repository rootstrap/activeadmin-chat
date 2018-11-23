FactoryBot.define do
  factory :conversation do
    person

    trait :with_texts do
      after(:create) do |instance, evaluator|
        create_list :text, evaluator.text_count, sender: instance.person, conversation: instance
      end
    end
  end
end
