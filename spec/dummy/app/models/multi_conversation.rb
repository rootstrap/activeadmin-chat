class MultiConversation < ApplicationRecord
  belongs_to :multi_person, class_name: 'Api::MultiPerson'
  belongs_to :admin_user

  has_many :multi_texts, dependent: :destroy
end
