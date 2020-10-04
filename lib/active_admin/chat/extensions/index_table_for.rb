module ActiveAdmin
  module Chat
    module Extensions
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
              "#{ActiveAdmin::Chat.user_model_name}/#{id}/#{ActiveAdmin::Chat.page_name}"
            end
          end
        end
      end
    end
  end
end
