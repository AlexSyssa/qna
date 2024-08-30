require 'rails_helper'

feature 'User can vote the answer', "
  In order to show appreciation or discontent
  user would like to vote the answer
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Not an author of the question', js: true do
    background do
      sign_in other_user
      visit question_path(question)
    end

    scenario 'votes the question positively' do
      within '.answers' do
        click_on 'Upvote'

        within '.votes_answer' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes the question negatively' do
      within '.answers' do
        click_on 'Downvote'

        within '.votes_answer' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'cancels his rating' do
      within '.answers' do
        click_on 'Upvote'
        click_on 'Cancel'

        within '.votes_answer' do
          expect(page).to have_content '0'
        end
      end
    end
  end

  describe 'Author of question', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'tries to vote his question positively' do
      within '.answers' do
        expect(page).to_not have_link 'Upvote'
      end
    end

    scenario 'tries to vote his question negatively' do
      within '.answers' do
        expect(page).to_not have_link 'Downvote'
      end
    end

    scenario 'tries to cancel the rating' do
      within '.answers' do
        expect(page).to_not have_link 'Cancel'
      end
    end
  end
end
