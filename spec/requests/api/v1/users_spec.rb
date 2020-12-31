require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user1) { FactoryBot.create(:user) }

  describe 'GET /api/v1/users/:id' do
    it 'success/200' do
      get api_v1_user_path(user1.id)

      expect(response).to be_successful
      expect(response.status).to eq 200
    end

    it '正しくuser1の情報が返ること' do
      get api_v1_user_path(user1.id)
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json['name']).to eq user1.name
      expect(json['email']).to eq user1.email
    end
  end

  describe 'POST /api/v1/users' do
    let(:params1) { { user: FactoryBot.attributes_for(:user) } }

    context 'paramsが正しい場合' do
      it '正しくレコードが作成されること' do
        expect do
          post api_v1_users_path, params: params1
        end.to change(User, :count).by(1)
      end

      it '正しく作成したuserの属性値が返ること' do
        post api_v1_users_path, params: params1
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json['name']).to eq "#{params1[:user][:first_name]} #{params1[:user][:last_name]}"
        expect(json['email']).to eq params1[:user][:email]
      end
    end

    context 'paramsが不正な場合' do
      context 'paramsにfirst_nameがない場合' do
        let(:user_first_name_nil_params) { { user: FactoryBot.attributes_for(:user, first_name: nil) } }

        it 'レコードが作成されていないこと' do
          expect do
            post api_v1_users_path, params: user_first_name_nil_params
          end.to change(User, :count).by(0)
        end

        it 'エラーが返ること' do
          post api_v1_users_path, params: user_first_name_nil_params
          expect(response.status).to eq 400
          json = JSON.parse(response.body)
          expect(json['message']).to include "Validation failed: First name can't be blank"
        end
      end

      context 'paramsにlast_nameがない場合' do
        let(:user_last_name_nil_params) { { user: FactoryBot.attributes_for(:user, last_name: nil) } }

        it 'レコードが作成されていないこと' do
          expect do
            post api_v1_users_path, params: user_last_name_nil_params
          end.to change(User, :count).by(0)
        end

        it 'エラーが返ること' do
          post api_v1_users_path, params: user_last_name_nil_params
          expect(response.status).to eq 400
          json = JSON.parse(response.body)
          expect(json['message']).to include "Validation failed: Last name can't be blank"
        end
      end

      context 'paramsにemailが重複する場合' do
        let(:user_duplicated_email_params) { { user: FactoryBot.attributes_for(:user, email: params1[:user][:email]) } }

        before do
          User.create(params1[:user])
        end

        it 'レコードが作成されていないこと' do
          expect do
            post api_v1_users_path, params: user_duplicated_email_params
          end.to change(User, :count).by(0)
        end

        it 'エラーが返ること' do
          post api_v1_users_path, params: user_duplicated_email_params
          expect(response.status).to eq 400
          json = JSON.parse(response.body)
          expect(json['message']).to include 'Validation failed: Email has already been taken'
        end
      end
    end
  end
end
