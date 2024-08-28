module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def upvote(user)
    votes.create!(user: user, value: 1) unless votes.exists?(user: user)
  end

  def downvote(user)
    votes.create!(user: user, value: -1) unless votes.exists?(user: user)
  end

  def cancel_vote(user)
    votes.find_by(user: user).destroy
  end

  def total_rating
    votes.sum(:value)
  end
end
