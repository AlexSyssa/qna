class AnswersController < ApplicationController
  before_action :find_question, only: %i[ create ]
  before_action :find_answer, only: %i[ destroy ]
  before_action :authenticate_user!, except: [ :show ]

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      flash[:notice] = 'Answer was successfully created.'
    else
      flash[:alert] = @answer.errors.full_messages if @answer.errors.present?
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer was successfully deleted.'
    else
      flash[:alert] = "You can't delete another answer."
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end