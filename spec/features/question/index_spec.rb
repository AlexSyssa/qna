require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to get answer from a community
  I'd like to be able view questions
} do

  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario 'User views a list of questions' do
    visit questions_path

    questions.each do |question|
      #Не проходит этот тест, якобы не видит заголовок вопроса, при этом он нормально отображается на странице
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'question and answers for this question' do
    visit questions_path

    expect(page).to have_content 'Question title'
    expect(page).to have_content 'Question body'
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end

