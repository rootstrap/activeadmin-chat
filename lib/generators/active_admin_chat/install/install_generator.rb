module ActiveAdminChat
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      argument :name, default: ''
      class_option :conversation_model_name, type: :string, default: 'conversation'
      class_option :message_model_name, type: :string, default: 'message'
      class_option :admin_user_model_name, type: :string, default: 'admin_user'
      class_option :user_model_name, type: :string, default: 'user'

      source_root File.expand_path('templates', __dir__)

      def normalize_config
        @conversation_model_name = options['conversation_model_name'].underscore.singularize
        @message_model_name = options['message_model_name'].underscore.singularize
        @admin_user_model_name = options['admin_user_model_name'].underscore.singularize
        @user_model_name = options['user_model_name'].underscore.singularize
      end

      def copy_initializer
        template 'active_admin_chat.rb.erb', 'config/initializers/active_admin_chat.rb'
      end

      def create_models
        unless model_exists?(@conversation_model_name)
          Rails::Generators.invoke('active_record:model', [
                                     @conversation_model_name,
                                     "#{@user_model_name.split('/').last}_id:integer:index",
                                     '--migration',
                                     '--timestamps'
                                   ])
        end

        unless model_exists?(@message_model_name)
          Rails::Generators.invoke('active_record:model', [
                                     @message_model_name,
                                     'content:string',
                                     'sender:references{polymorphic}',
                                     "#{@conversation_model_name.split('/').last}_id:integer:index",
                                     '--migration',
                                     '--timestamps'
                                   ])
        end
      end

      def inject_models_contents
        if model_exists?(@conversation_model_name)
          inject_into_class(
            model_path(@conversation_model_name),
            @conversation_model_name.classify,
            conversation_contents
          )
        end

        if model_exists?(@message_model_name)
          inject_into_class(
            model_path(@message_model_name),
            @message_model_name.classify,
            message_contents
          )
        end
      end

      def insert_chat_page
        template 'chat.rb', 'app/admin/chat.rb'
      end

      private

      def conversation_contents
        buffer = <<-CONTENT
  #{add_belongs_to(@user_model_name)}
  #{add_has_many(@message_model_name)}
        CONTENT

        buffer
      end

      def message_contents
        buffer = <<-CONTENT
  #{add_belongs_to(@conversation_model_name)}
        CONTENT

        buffer
      end

      def add_belongs_to(model_name)
        if model_name.include?('/')
          "belongs_to :#{model_name.split('/').last}, class_name: '#{model_name.classify}'"
        else
          "belongs_to :#{model_name}"
        end
      end

      def add_has_many(model_name)
        if model_name.include?('/')
          "has_many :#{model_name.split('/').last.pluralize}, class_name: #{model_name.classify}"
        else
          "has_many :#{model_name.pluralize}"
        end
      end

      def model_exists?(model_name)
        File.exist?(File.join(destination_root, model_path(model_name)))
      end

      def model_path(model_name)
        File.join('app', 'models', "#{model_name}.rb")
      end
    end
  end
end
