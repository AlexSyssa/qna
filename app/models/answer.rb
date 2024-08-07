# frozen_string_literal: true

class Answer < ApplicationRecord
  has_many_attached :files

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc, created_at: :asc) }

  def mark_as_best
    transaction do
      self.class.where(question_id: question_id).update_all(best: false)
      update(best: true)
    end
  end
end
