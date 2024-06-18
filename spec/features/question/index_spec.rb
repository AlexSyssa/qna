require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to get answer from a community
  I'd like to be able view questions
} do

  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }


  scenario 'User views a list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_field("Title", :with => "#{question.title}")
      expect(page).to have_content question.body
    end
  end

  scenario 'Answers for this question' do
    visit questions_path

    answers.each do |answer|
      expect(page).to have_content answer.body
    end

  end
end