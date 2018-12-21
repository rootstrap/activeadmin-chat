class MultiText < ApplicationRecord
  belongs_to :multi_conversation
  belongs_to :sender, polymorphic: true
end
