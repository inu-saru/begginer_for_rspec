require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    it 'first_name, first_name, emailがある場合、有効な状態であること' do
      user1 = User.new(
        first_name: 'Taro',
        last_name: 'Yamada',
        email: 'tester@example.com'
      )
      expect(user1).to be_valid
    end

    context 'first_nameがない場合' do
      it '無効な状態であること' do
        user_first_name_nil = User.new(
          first_name: nil,
          last_name: 'Yamada',
          email: 'tester@example.com'
        )
        user_first_name_nil.valid?
        expect(user_first_name_nil.errors[:first_name]).to include("can't be blank")
      end
    end

    context 'last_nameがない場合' do
      it '無効な状態であること' do
        user_last_name_nil = User.new(
          first_name: 'Taro',
          last_name: nil,
          email: 'tester@example.com'
        )
        user_last_name_nil .valid?
        expect(user_last_name_nil .errors[:last_name]).to include("can't be blank")
      end
    end

    context 'emailが重複する場合' do
      it '無効な状態であること' do
        user1 = User.new(
          first_name: 'Taro',
          last_name: 'Yamada',
          email: 'tester@example.com'
        )
        user1.save
        user_duplicated_email = User.new(
          first_name: 'Jiro',
          last_name: 'Sato',
          email: 'tester@example.com'
        )
        user_duplicated_email.valid?
        expect(user_duplicated_email.errors[:email]).to include('has already been taken')
      end
    end
  end

  describe 'name' do
    it '指名が正しく返ること' do
      user1 = User.new(
        first_name: 'Taro',
        last_name: 'Yamada',
        email: 'tester@example.com'
      )
      expect(user1.name).to eq 'Taro Yamada'
    end
  end

  describe 'all_names' do
    context 'Userレコードがない場合' do
      it '[]が返ること' do
        expect(User.all_names).to eq []
      end
    end

    context 'Userレコードがある場合' do
      it '全ての指名リストが返ること' do
        user1 = User.create(
          first_name: 'Taro',
          last_name: 'Yamada',
          email: 'tester@example.com'
        )
        user2 = User.create(
          first_name: 'Jiro',
          last_name: 'Sato',
          email: 'tester2@example.com'
        )
        expect(User.all_names).to include 'Taro Yamada'
        expect(User.all_names).to include 'Jiro Sato'
      end
    end
  end
end
