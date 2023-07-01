# frozen_string_literal: true

module ControllerMacros
  def login_qa
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in User.create(name: 'abc', password: 'qwerty',
                          password_confirmation: 'qwerty', email: 'alia@gmail.com', user_type: 2)
    end
  end

  def login_developer
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:developer]
      sign_in User.create(name: 'abc', password: 'qwerty',
                          password_confirmation: 'qwerty', email: 'alia010@gmail.com', user_type: 0)
    end
  end

  def login_manager
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      sign_in user
    end
  end
end
