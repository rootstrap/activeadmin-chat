require 'rails_helper'
require 'timecop'
require 'factories/admin_user'
require 'factories/conversation'
require 'factories/person'

describe ChatChannel, type: :channel do
  context 'with an admin user' do
    let!(:admin) { create(:admin_user) }

    before do
      stub_connection current_user: admin
    end

    context 'when there are no conversations' do
      it "rejects if conversation_id isn't present" do
        subscribe

        expect(subscription).to be_rejected
      end

      it "rejects if conversation doesn't exist" do
        subscribe(conversation_id: 42)

        expect(subscription).to be_rejected
      end
    end

    context 'when there are conversations' do
      let!(:conversation) { create(:conversation) }

      it "rejects if conversation_id isn't present" do
        subscribe

        expect(subscription).to be_rejected
      end

      it 'subscribes to a stream' do
        subscribe(conversation_id: conversation.id)

        expect(subscription).to be_confirmed
        expect(streams).to eq(["chat:#{conversation.to_gid_param}"])
      end

      it 'broadcasts a message' do
        subscribe(conversation_id: conversation.id)
        expect { perform :speak, message: 'A new message' }.to(
          have_broadcasted_to(conversation).from_channel(ChatChannel).with(
            "<div id=\"message-1\" class=\"active-admin-chat__message-container admin\">\n  <p>A new message</p>\n</div>\n"
          )
        )
      end

      it 'stores the message in the database' do
        subscribe(conversation_id: conversation.id)

        expect { perform :speak, message: 'A new message' }.to change {
          Text.count
        }.by(1)
      end
    end
  end

  context 'with non admin users' do
    let(:person) { create(:person) }

    before do
      stub_connection current_user: person
    end

    context 'when there is no conversation' do
      it 'rejects the subscription' do
        subscribe

        expect(subscription).to be_rejected
      end

      it 'rejects ignoring the conversation_id' do
        other_conversation = create(:conversation)
        subscribe(conversation_id: other_conversation.id)

        expect(subscription).to be_rejected
      end
    end

    context 'when there are conversations' do
      let!(:conversation) { create(:conversation, person: person) }

      it 'subscribes to a stream' do
        subscribe

        expect(subscription).to be_confirmed
        expect(streams).to eq(["chat:#{conversation.to_gid_param}"])
      end

      it "subscribes to the user's conversation stream ignoring the conversation_id" do
        other_conversation = create(:conversation)
        subscribe(conversation_id: other_conversation.id)

        expect(subscription).to be_confirmed
        expect(streams).to eq(["chat:#{conversation.to_gid_param}"])
      end

      it 'broadcasts a message' do
        subscribe

        expect { perform :speak, message: 'A new message' }.to(
          have_broadcasted_to(conversation).from_channel(ChatChannel).with(
            "<div id=\"message-1\" class=\"active-admin-chat__message-container \">\n  <p>A new message</p>\n</div>\n"
          )
        )
      end

      it 'stores the message in the database' do
        subscribe

        expect { perform :speak, message: 'A new message' }.to change {
          Text.count
        }.by(1)
      end
    end
  end
end
