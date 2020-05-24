Rails.application.routes.draw do
  if ActiveAdmin::Chat.method_defined?(:page_name) && ActiveAdmin::Chat.page_name
    namespace ActiveAdmin::Chat.namespace do
      get  "#{ActiveAdmin::Chat.page_name}/:id", to: "#{ActiveAdmin::Chat.page_name}#show"
      post "#{ActiveAdmin::Chat.user_model_name}/:#{ActiveAdmin::Chat.user_relation_name}_id/#{ActiveAdmin::Chat.page_name}",
           to: "#{ActiveAdmin::Chat.page_name}#create"
    end
  end
end
