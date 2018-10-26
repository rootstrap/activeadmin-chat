module ActiveAdminChat
  module ActiveAdmin
    module Views
      module IndexAsTable
        module IndexTableFor
          def send_message_link(resource)
            text_node link_to 'Send Message',
                              "#{ActiveAdminChat.user_model_name}/#{resource.id}/#{ActiveAdminChat.page_name}",
                              method: :post
          end
        end
      end
    end
  end
end
