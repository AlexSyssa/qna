# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  # given!(:answer) { create(:answer, question: question, user: user) }
  given(:gist_url) { 'https://github.com' }

  scenario 'User adds link when ask question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answer' do
      fill_in 'Answer:', with: 'Answer_link'

      within '.attachable-links' do
        fill_in 'link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end
      click_on 'Create Answer'
    end

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  scenario 'edits his answer by adding links', js: true do
    sign_in(user)
    visit questions_path

    click_on 'Edit'
    click_on 'Add link'
    within '.attachable-links' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    click_on 'Update Answer'
    expect(page).to have_link 'My gist', href: gist_url
  end
end
