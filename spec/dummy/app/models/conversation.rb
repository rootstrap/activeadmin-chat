class Conversation < ApplicationRecord
  belongs_to :person, class_name: 'Api::Person'
  has_many :texts, dependent: :destroy
end
