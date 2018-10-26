Rails.application.routes.draw do
  if ActiveAdminChat.method_defined?(:page_name) && ActiveAdminChat.page_name
    namespace ActiveAdminChat.namespace do
      get "#{ActiveAdminChat.page_name}/:id", to: "#{ActiveAdminChat.page_name}#show"
    end
  end
end
