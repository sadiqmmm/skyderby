require 'spec_helper'

describe 'Registration & sign in', :type => :feature do

  before(:all) do
    FactoryGirl.create(:user_role)
    FactoryGirl.create(:admin_role)
    FactoryGirl.create(:create_events_role)

    @user = FactoryGirl.build(:user)
  end

  it 'register me' do
    visit root_path
    click_link 'Зарегистрироваться'

    within '#new_user' do
      fill_in 'Email', :with => @user.email
      fill_in 'Password', :with => @user.password
      fill_in 'Password confirmation', :with => @user.password_confirmation

      expect { click_button 'Sign up' }.to change(User, :count).by(1)
    end

    expect(page).to have_content ('В течение нескольких минут Вы получите письмо с инструкциями по подтверждению Вашей учётной записи.')

  end

  it 'create profile' do
    @user = User.find 1
    expect(@user.user_profile.present?).to be_truthy
  end

  it 'give me right permissions' do
    @user = User.find 1
    expect(@user.has_role?(:user)).to be_truthy
    expect(@user.has_role?(:create_events)).to be_falsey
    expect(@user.has_role?(:admin)).to be_falsey
  end

  it 'logged me in' do
    User.find(1).update(:confirmed_at => Time.now)

    visit root_path
    click_link 'Войти'

    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => @user.password

    within '.dropdown-menu.login-menu' do
      click_button 'Войти'
    end

    expect(page).to have_content 'Вход в систему выполнен.'
  end

end

describe 'Competition' do

  before(:all) do
    @competitor1 = FactoryGirl.create(:user)
    @competitor2 = FactoryGirl.create(:user)
    @competitor3 = FactoryGirl.create(:user)

    @organizer= FactoryGirl.create(:user)
  end

  it 'create competition' do

  end

end