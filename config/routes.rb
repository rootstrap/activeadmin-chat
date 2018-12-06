Rails.application.routes.draw do
  if ActiveAdminChat.method_defined?(:page_name) && ActiveAdminChat.page_name
    namespace ActiveAdminChat.namespace do
      get  "#{ActiveAdminChat.page_name}/:id", to: "#{ActiveAdminChat.page_name}#show"
      post "#{ActiveAdminChat.user_model_name}/:#{ActiveAdminChat.user_relation_name}_id/#{ActiveAdminChat.page_name}",
           to: "#{ActiveAdminChat.page_name}#create"
    end
  end
end
