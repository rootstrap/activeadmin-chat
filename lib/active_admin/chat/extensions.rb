module ActiveAdmin
  module Chat
    module Extensions
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        delegate :register_chat, to: :application
      end
    end
  end
end
