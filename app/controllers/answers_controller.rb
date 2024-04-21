class AnswersController < ApplicationController
  before_action :find_question
  def create
    @answer = @question.answers.create(answer_params)
    if @answer.save
      flash[:notice] = 'Answer was successfully created.'
    else
      render :create
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
