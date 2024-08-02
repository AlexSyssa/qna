# frozen_string_literal: true

require 'rails_helper'

feature 'User can give an answer', '
  In order to share my knowledge
  As an authenticated user
  I want to be able to create answers
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer', js: true do
      fill_in 'Your answer', with: 'My answer'
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'My answer'
      end
    end

    scenario 'create answer with attached file', js: true do
      fill_in 'Your answer', with: 'My answer'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'creates answer with errors', js: true do
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end
  end
end
