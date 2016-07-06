require 'rails_helper'

describe ApplicationController, type: :controller do

  describe 'auth token' do
    before :each do
      @user = create(:user)
      expect(@user.auth_token).not_to be nil
    end

    it 'token is not present' do
      get :index
      expect(controller.current_user).to be nil
    end

    it 'wrong token is present' do
      get :index, auth_token: '123'
      expect(controller.current_user).to be nil
    end

    it 'correct token is present' do
      get :index, auth_token: @user.auth_token
      expect(controller.current_user.id).to be @user.id
    end

  end

end
