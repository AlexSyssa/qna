require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  scenario 'User tries to sign up with valid params ' do

    fill_in 'Email', with: "user@mail.ru"
    fill_in 'Password', with: '567890876'
    fill_in 'Password confirmation', with: '567890876'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with errors' do
    click_on 'Sign up'

    expect(page).to have_content '2 errors prohibited this user from being saved:'
  end

  scenario 'User tries to sign up with invalid params, without password confirmation' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '567890876'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end