# frozen_string_literal: true

require 'rails_helper'

feature 'User can log out', "
  I'd like to be able to log out
" do
  given(:user) { create(:user) }
  background { sign_in(user) }

  scenario 'Registered user tries to log out' do
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
