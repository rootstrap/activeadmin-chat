require 'rails_helper'

describe ActiveAdmin::Chat::UserChannel, type: :channel do
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
        expect(subscription).to have_stream_for(conversation)
      end

      it "subscribes to the user's conversation stream ignoring the conversation_id" do
        other_conversation = create(:conversation)
        subscribe(conversation_id: other_conversation.id)

        expect(subscription).to be_confirmed
        expect(subscription).to have_stream_for(conversation)
      end

      it 'broadcasts a message to the admin channel' do
        freeze_time do
          subscribe

          expect { perform :speak, message: 'A new message' }.to(
            have_broadcasted_to(conversation).from_channel(ActiveAdmin::Chat::AdminChannel).with(
              'id': 1,
              'message': 'A new message',
              'date': Time.current.iso8601(3),
              'is_admin': false
            ).once
          )
        end
      end

      it 'broadcasts a message to the user channel' do
        freeze_time do
          subscribe

          expect { perform :speak, message: 'A new message' }.to(
            have_broadcasted_to(conversation).from_channel(ActiveAdmin::Chat::UserChannel).with(
              'id': 1,
              'message': 'A new message',
              'date': Time.current.iso8601(3),
              'is_admin': false
            ).once
          )
        end
      end

      it 'stores the message in the database' do
        subscribe

        expect { perform :speak, message: 'A new message' }.to change {
          conversation.texts.count
        }.by(1)
      end
    end
  end
end
