module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, value)
    votes.create!(user: user, value: value) unless votes.exists?(user: user)
  end

  def upvote(user)
    vote(user, 1)
  end

  def downvote(user)
    vote(user, -1)
  end

  def cancel_vote(user)
    votes.find_by(user: user).destroy
  end

  def total_rating
    votes.sum(:value)
  end
end
