# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
In order to correct mistakes
As an author of answer
I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "tries to edit other user's question", js: true do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content('Edit')
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Update'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end

    scenario 'edit answer with attached file', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'My answer'

        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Update'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edits his answer by delete attached file' do
      click_on 'Edit'

      within '.answers' do
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Update'

        click_on 'Delete File'
      end

      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to have_content('Attachment was successfully deleted.')
    end
  end
end
