require 'spec_helper'
require 'generator_spec'
# Generators are not automatically loaded by Rails
require 'generators/active_admin_chat/install/install_generator'
require 'rails/generators/active_record/model/model_generator'

describe ActiveAdminChat::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)
  ActiveRecord::Generators::ModelGenerator.send(:include, TestDestinationRoot)
  arguments %w[--conversation_model_name=chat --user_model_name=Api::User --multi-chat]

  before do
    prepare_destination
    run_generator
  end

  specify do
    expect(destination_root).to have_structure {
      directory 'app' do
        directory 'admin' do
          file 'chat.rb' do
            contains "ActiveAdmin.register_chat 'Chat' do"
          end
        end
        directory 'models' do
          file 'chat.rb' do
            contains 'class Chat < ApplicationRecord'
            contains "belongs_to :user, class_name: 'Api::User'"
            contains 'belongs_to :admin_user'
            contains 'has_many :messages, dependent: :destroy'
          end
          file 'message.rb' do
            contains 'class Message < ApplicationRecord'
            contains 'belongs_to :chat'
            contains 'belongs_to :sender, polymorphic: true'
          end
        end
      end
      directory 'config' do
        directory 'initializers' do
          file 'active_admin_chat.rb' do
            contains 'ActiveAdminChat.setup do |config|'
            contains "config.conversation_model_name = 'chat'"
            contains "config.message_model_name = 'message'"
            contains "config.admin_user_model_name = 'admin_user'"
            contains "config.user_model_name = 'api/user'"
            contains 'config.messages_per_page = 25'
          end
        end
      end
      directory 'db' do
        directory 'migrate' do
          migration 'create_chats' do
            contains 'class CreateChats < ActiveRecord::Migration'
            contains 'create_table :chats'
            contains 'integer :user_id'
            contains 'integer :admin_user_id'
            contains 'timestamps'
            contains 'add_index :chats, :user_id'
            contains 'add_index :chats, :admin_user_id'
          end
          migration 'create_messages' do
            contains 'class CreateMessages < ActiveRecord::Migration'
            contains 'create_table :messages do |t|'
            contains 'string :content'
            contains 'references :sender, polymorphic: true'
            contains 'integer :chat_id'
            contains 'datetime :created_at'
            contains 'datetime :updated_at'
            contains 'add_index :messages, :chat_id'
            contains 'add_index :messages, :created_at'
          end
        end
      end
    }
  end
end
