require 'active_admin'
require 'active_admin_chat/engine'
require 'active_admin_chat/active_admin'
require 'active_admin_chat/active_admin/application'
require 'active_admin_chat/application'
require 'active_admin_chat/message_presenter'

module ActiveAdminChat
  extend self

  def application
    @application ||= ::ActiveAdminChat::Application.new
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
end

::ActiveAdmin.send :include, ActiveAdminChat::ActiveAdmin
::ActiveAdmin::Application.send :include, ActiveAdminChat::ActiveAdmin::Application
