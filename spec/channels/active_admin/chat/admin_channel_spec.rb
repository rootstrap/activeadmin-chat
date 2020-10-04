require 'rails_helper'

describe ActiveAdmin::Chat::AdminChannel, type: :channel do
  context 'with an admin user' do
    let(:admin) { create(:admin_user) }

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
        expect(subscription).to have_stream_for(conversation)
      end

      it 'broadcasts a message to the admin channel' do
        freeze_time do
          subscribe(conversation_id: conversation.id)
          expect { perform :speak, message: 'A new message' }.to(
            have_broadcasted_to(conversation).from_channel(ActiveAdmin::Chat::AdminChannel).with(
              'id': 1,
              'message': 'A new message',
              'date': Time.current.iso8601(3),
              'is_admin': true
            ).once
          )
        end
      end

      it 'broadcasts a message to the user channel' do
        freeze_time do
          subscribe(conversation_id: conversation.id)
          expect { perform :speak, message: 'A new message' }.to(
            have_broadcasted_to(conversation).from_channel(ActiveAdmin::Chat::UserChannel).with(
              'id': 1,
              'message': 'A new message',
              'date': Time.current.iso8601(3),
              'is_admin': true
            ).once
          )
        end
      end

      it 'stores the message in the database' do
        subscribe(conversation_id: conversation.id)

        expect { perform :speak, message: 'A new message' }.to change {
          conversation.texts.count
        }.by(1)
      end
    end
  end
end
