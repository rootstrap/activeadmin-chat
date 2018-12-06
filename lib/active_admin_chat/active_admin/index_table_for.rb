module ActiveAdminChat
  module ActiveAdmin
    module Views
      module IndexAsTable
        module IndexTableFor
          def send_message_link(resource)
            text_node link_to 'Send Message',
                              send_message_path(resource.id),
                              method: :post
          end

          private

          def send_message_path(id)
            "#{ActiveAdminChat.user_model_name}/#{id}/#{ActiveAdminChat.page_name}"
          end
        end
      end
    end
  end
end
