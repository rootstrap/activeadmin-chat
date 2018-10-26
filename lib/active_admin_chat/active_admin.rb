module ActiveAdminChat
  module ActiveAdmin
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      delegate :register_chat, to: :application
    end
  end
end
