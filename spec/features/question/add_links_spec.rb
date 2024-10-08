# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://github.com' }

  scenario 'User adds link when ask question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'
    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'edits his question by adding links', js: true do
    sign_in(user)
    visit questions_path

    click_on 'Edit'
    within '.attachable-links' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    click_on 'Save'
    expect(page).to have_link 'My gist', href: gist_url
  end
end
