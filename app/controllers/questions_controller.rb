class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]
  before_action :find_question, only: [ :show, :update, :destroy ]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.sort_by_best
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
      flash[:alert] = "You can't edited another question."
    end
  end

  def edit
  end

  def update
    if current_user.author?(@question)
      @question.update(question_params)
      redirect_to @question, notice: 'Your question successfully updated'
    else
      render :edit
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      flash[:notice] = 'Your question successfully updated'
    else
      flash[:alert] = "Your question could not be destroyed, you are not author of the question"
    end
    redirect_to questions_path
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end