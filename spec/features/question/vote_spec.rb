require 'rails_helper'

feature 'User can vote the question', "
  In order to show appreciation or discontent
  user would like to rate the question
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Not an author of the question', js: true do
    background do
      sign_in other_user
      visit question_path(question)
    end

    scenario 'votes the question positively' do
      click_on 'Upvote'

      within '.question' do
        expect(page).to have_content '1'
      end
    end

    scenario 'votes the question negatively' do
      click_on 'Downvote'

      within '.question' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'cancels his rating' do
      click_on 'Upvote'
      click_on 'Cancel'

      within '.question' do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Author of question', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'tries to vote his question positively' do
      expect(page).to_not have_link 'Upvote'
    end

    scenario 'tries to vote his question negatively' do
      expect(page).to_not have_link 'Downvote'
    end

    scenario 'tries to cancel the rating' do
      expect(page).to_not have_link 'Cancel'
    end
  end

  describe 'Unauthorized user' do
    background { visit questions_path }

    scenario 'tries to vote the question positively' do
      expect(page).to_not have_link 'Upvote'
    end

    scenario 'tries to vote the question negatively' do
      expect(page).to_not have_link 'Downvote'
    end

    scenario 'tries to cancel the rating' do
      expect(page).to_not have_link 'Cancel'
    end
  end
end
