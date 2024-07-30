# frozen_string_literal: true
require 'rails_helper'

feature 'User is able to delete his answer', '
  user would like to delete his answer
  in order to seek help from community
' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'User tries to delete his answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete Answer'

    expect(page).to_not have_content answer.body
  end

  scenario "User tries to delete another's answer" do
    sign_in(other_user)
    visit question_path(question)

    expect(page).not_to have_content('Delete Answer')
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).not_to have_content('Delete Answer')
  end
end
