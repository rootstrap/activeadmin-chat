FactoryBot.define do
  factory :multi_person, class: 'Api::MultiPerson' do
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
