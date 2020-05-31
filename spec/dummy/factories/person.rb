FactoryBot.define do
  factory :person, class: 'Api::Person' do
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
