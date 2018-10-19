require "active_admin"
require "active_admin_chat/engine"
require "active_admin_chat/active_admin"
require "active_admin_chat/active_admin/application"

::ActiveAdmin.send :include, ActiveAdminChat::ActiveAdmin
::ActiveAdmin::Application.send :include, ActiveAdminChat::ActiveAdmin::Application
