require 'rails_helper'

describe ActiveAdmin::Chat::ChatHelper, type: :helper do
  describe '#admin_class' do
    let!(:admin_user) { create(:admin_user) }
    let!(:person) { create(:person) }
    let!(:conversation) { create(:conversation, person: person) }

    it "returns 'admin' if message sender is an admin" do
      text = create(:text, sender: admin_user, conversation: conversation)

      expect(helper.admin_class(text)).to eq('admin')
    end

    it 'returns nil if message sender is not an admin' do
      text = create(:text, sender: person, conversation: conversation)

      expect(helper.admin_class(text)).to be_nil
    end
  end

  describe '#selected_class' do
    let!(:admin_user) { create(:admin_user) }
    let!(:person1) { create(:person) }
    let!(:person2) { create(:person) }
    let!(:conversation1) { create(:conversation, person: person1) }
    let!(:conversation2) { create(:conversation, person: person2) }

    it "returns 'selected' if both conversations are the same one" do
      expect(helper.selected_class(conversation1, conversation1)).to eq('selected')
    end

    it 'returns nil if conversations are different' do
      expect(helper.selected_class(conversation1, conversation2)).to be_nil
    end
  end
end
