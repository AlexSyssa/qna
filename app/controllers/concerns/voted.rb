module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[upvote downvote cancel]
  end

  def upvote
    return render_error if current_user.author?(@votable)

    @votable.upvote(current_user)
    redirect_to request.referer || root_path, notice: 'You voted!'
  end

  def downvote
    return render_error if current_user.author?(@votable)

    @votable.downvote(current_user)

    redirect_to request.referer || root_path, notice: 'You voted!'
  end

  def cancel
    return render_error if current_user.author?(@votable)

    @votable.cancel_vote(current_user)
    redirect_to request.referer || root_path, notice: 'Your vote successfully updated'
  end

  private

  def render_error
    render json: { message: "You can't vote on your own content" }, status: 422
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end
end
