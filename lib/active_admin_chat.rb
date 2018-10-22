require 'active_admin'
require 'active_admin_chat/engine'
require 'active_admin_chat/active_admin'
require 'active_admin_chat/active_admin/application'
require 'active_admin_chat/application'

module ActiveAdminChat
  extend self

  def application
    @application ||= ::ActiveAdminChat::Application.new
  end

  def setup
    yield(application)
  end
end

::ActiveAdmin.send :include, ActiveAdminChat::ActiveAdmin
::ActiveAdmin::Application.send :include, ActiveAdminChat::ActiveAdmin::Application
