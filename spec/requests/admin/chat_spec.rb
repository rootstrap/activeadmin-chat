require 'rails_helper'
require 'timecop'
require 'factories/conversation'
require 'factories/person'

describe 'GET /admin/chat/:id', type: :request do
  let!(:person) { create(:person) }

  it 'returns a successful response' do
    Timecop.freeze(Time.current) do
      conversation = create(:conversation, :with_texts, text_count: 2, person: person)

      get "/admin/chat/#{conversation.id}"

      expect(response).to have_http_status(:success)
      expect(response.parsed_body).to eq(
        'messages' => [
          {
            'id' => 1,
            'message' => 'Content',
            'date' => Time.current.iso8601(3),
            'is_admin' => false
          },
          {
            'id' => 2,
            'message' => 'Content',
            'date' => Time.current.iso8601(3),
            'is_admin' => false
          }
        ]
      )
    end
  end

  it 'paginates messages' do
    conversation = create(:conversation, :with_texts, text_count: 30, person: person)

    get "/admin/chat/#{conversation.id}"

    expect(response).to have_http_status(:success)
    expect(response.parsed_body['messages'].size).to eq(25)

    get "/admin/chat/#{conversation.id}", params: { page: 2 }

    expect(response).to have_http_status(:success)
    expect(response.parsed_body['messages'].size).to eq(5)
  end
end
