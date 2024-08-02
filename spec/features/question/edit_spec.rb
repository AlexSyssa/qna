# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    context 'Author' do
      background do
        sign_in(user)
        visit questions_path
      end

      scenario 'edits his question' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited title'
        fill_in 'Your question', with: 'edited question'
        click_on 'Update Question'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited question'
      end

      scenario 'edits his question with attached file' do
        click_on 'Edit'

        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Update Question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'edits his question by delete attached file' do
        click_on 'Edit'

        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Update Question'
        click_on 'Back'
        click_on 'Edit'

        click_on 'Delete File'
        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to have_content('Attachment was successfully deleted.')
      end
    end

    context 'Not author' do
      scenario "tries to edit other user's question" do
        sign_in(user)
        visit question_path(question)

        expect(page).not_to have_content('Edit')
      end
    end
  end
end
