require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { FactoryBot.build(:user) }
  let(:user2) { FactoryBot.build(:user) }

  describe 'validation' do
    it 'first_name, first_name, emailがある場合、有効な状態であること' do
      expect(user1).to be_valid
    end

    context 'first_nameがない場合' do
      let(:user_first_name_nil) { FactoryBot.build(:user, first_name: nil) }

      it '無効な状態であること' do
        user_first_name_nil.valid?
        expect(user_first_name_nil.errors[:first_name]).to include("can't be blank")
      end
    end

    context 'last_nameがない場合' do
      let(:user_last_name_nil) { FactoryBot.build(:user, last_name: nil) }

      it '無効な状態であること' do
        user_last_name_nil .valid?
        expect(user_last_name_nil .errors[:last_name]).to include("can't be blank")
      end
    end

    context 'emailが重複する場合' do
      let(:user_duplicated_email) { FactoryBot.build(:user, email: user1.email) }

      before do
        user1.save
      end

      it '無効な状態であること' do
        user_duplicated_email.valid?
        expect(user_duplicated_email.errors[:email]).to include('has already been taken')
      end
    end
  end

  describe 'name' do
    it '指名が正しく返ること' do
      expect(user1.name).to eq "#{user1.first_name} #{user1.last_name}"
    end
  end

  describe 'all_names' do
    context 'Userレコードがない場合' do
      it '[]が返ること' do
        expect(User.all_names).to eq []
      end
    end

    context 'Userレコードがある場合' do
      before do
        user1.save
        user2.save
      end

      it '全ての指名リストが返ること' do
        expect(User.all_names).to include "#{user1.first_name} #{user1.last_name}"
        expect(User.all_names).to include "#{user2.first_name} #{user2.last_name}"
      end
    end
  end
end
