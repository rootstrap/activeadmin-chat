FactoryBot.define do
  factory :multi_conversation do
    multi_person

    trait :with_texts do
      after(:create) do |instance, evaluator|
        create_list(:multi_text, evaluator.multi_text_count, sender: instance.multi_person,
                                                             multi_conversation: instance)
      end
    end
  end
end
