require 'rails_helper'

feature "User is able to mark answers as best", %q{
  In order to choose the best answer
  user would like to mark answer as best
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe "Authenticated user" do
    scenario "Author of the question marks answer as best", js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Mark as Best'

        expect(page).to have_content('Best Answer')
      end
    end

    scenario "Non-author tries to mark answer as best" do
      sign_in(other_user)
      visit question_path(question)

      expect(page).not_to have_content('Mark As Best')
    end
  end

  scenario "Unauthenticated user tries to mark answer as best" do
    visit question_path(question)

    expect(page).not_to have_content('Mark As Best')
  end
end