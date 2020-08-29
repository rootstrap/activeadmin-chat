require 'active_admin'
require 'active_admin/chat/engine'
require 'active_admin/chat/extensions'
require 'active_admin/chat/extensions/application'
require 'active_admin/chat/application'
require 'active_admin/chat/extensions/index_table_for'
require 'active_admin/chat/message_presenter'
require 'motion'
require 'view_component/engine'
require 'webpacker'

module ActiveAdmin
  module Chat
    extend self

    def application
      @application ||= ::ActiveAdmin::Chat::Application.new
    end

    def setup
      yield(application)
    end

    delegate :conversation_klass, to: :application
    delegate :message_klass, to: :application
    delegate :admin_user_klass, to: :application
    delegate :user_klass, to: :application
    delegate :conversation_relation_name, to: :application
    delegate :message_relation_name, to: :application
    delegate :admin_user_relation_name, to: :application
    delegate :user_relation_name, to: :application
    delegate :page_name, to: :application
    delegate :namespace, to: :application
    delegate :user_model_name, to: :application
    delegate :messages_per_page, to: :application
  end
end

::ActiveAdmin.send :include, ActiveAdmin::Chat::Extensions
::ActiveAdmin::Application.send :include, ActiveAdmin::Chat::Extensions::Application
::ActiveAdmin::Views::IndexAsTable::IndexTableFor.send(
  :prepend,
  ActiveAdmin::Chat::Extensions::Views::IndexAsTable::IndexTableFor
)
