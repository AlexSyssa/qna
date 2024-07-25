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

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Update'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content(answer.body)
      end

      within '.answer-errors' do
        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario "tries to edit other user's question", js: true do
      sign_in(other_user)

      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_content('Edit')
      end
    end
  end
end
