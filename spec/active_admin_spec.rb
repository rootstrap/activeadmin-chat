require 'rails_helper'

describe ActiveAdmin do
  context '.register_chat' do
    it "calls application's #register_page" do
      subject { ActiveAdmin }

      expect(ActiveAdmin.application).to receive(:register_page).with(
        'My Page',
        namespace: 'public'
      )

      subject.register_chat 'My Page', namespace: 'public'
    end
  end
end
