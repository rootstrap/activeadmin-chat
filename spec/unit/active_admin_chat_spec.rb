require 'rails_helper'

describe ActiveAdminChat do
  context '.conversation_relation_name' do
    it 'returns the model name' do
      subject { ActiveAdminChat }

      expect(subject.conversation_relation_name).to eq('conversation')
    end
  end

  context '.message_relation_name' do
    it 'returns the model name' do
      subject { ActiveAdminChat }

      expect(subject.message_relation_name).to eq('text')
    end
  end

  context '.admin_user_relation_name' do
    it 'returns the model name' do
      subject { ActiveAdminChat }

      expect(subject.admin_user_relation_name).to eq('admin_user')
    end
  end

  context '.user_relation_name' do
    it 'returns the model name' do
      subject { ActiveAdminChat }

      expect(subject.user_relation_name).to eq('person')
    end
  end

  context '.conversation_klass' do
    it 'returns the class' do
      subject { ActiveAdminChat }

      expect(subject.conversation_klass).to eq(Conversation)
    end
  end

  context '.message_klass' do
    it 'returns the class' do
      subject { ActiveAdminChat }

      expect(subject.message_klass).to eq(Text)
    end
  end

  context '.admin_user_klass' do
    it 'returns the class' do
      subject { ActiveAdminChat }

      expect(subject.admin_user_klass).to eq(AdminUser)
    end
  end

  context '.user_klass' do
    it 'returns the class' do
      subject { ActiveAdminChat }

      expect(subject.user_klass).to eq(Api::Person)
    end
  end
end
