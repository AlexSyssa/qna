class AnswersController < ApplicationController
  before_action :find_question, only: %i[ new create show]
  before_action :find_answer, only: %i[ update destroy mark_as_best ]
  before_action :authenticate_user!, except: %i[ show ]

  def show
  end

  def index

  end

  def edit

  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Answer was successfully created.'
      respond_to do |format|
        format.js
        format.html { redirect_to @question }
      end
    else
      respond_to do |format|
        format.js { render 'create' }
        format.html { render :new }
      end
    end
  end

  def update
    if current_user.author?(@answer)

      if @answer.update(answer_params)
        @question = @answer.question
        @answers = @question.answers.sort_by_best
        respond_to do |format|
          format.js
          format.html { redirect_to @question }
          flash[:notice] = 'Your answer was successfully updated.'
        end
      end
    else
      respond_to do |format|
        format.js { render 'update' }
        format.html { render :edit }
      end
      flash[:alert] = "You can't edited another answer."
    end
  end


  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      @question = @answer.question
      @answers = @question.answers.sort_by_best
      respond_to do |format|
        format.js
        format.html { redirect_to @question }
        flash[:notice] = 'Your answer was successfully deleted.'
      end
    else
      respond_to do |format|
        format.js
        format.html { redirect_to root_path}
        end
      flash[:alert] = "You can't delete another answer."
    end
  end

  def mark_as_best
    if current_user.author?(@answer.question)
      @answer.mark_as_best
      @question = @answer.question
      @answers = @answer.question.answers.sort_by_best
      redirect_to @question, notice: 'This answer is selected as best'
    else
      flash[:alert] = "You can't select another answer!"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end