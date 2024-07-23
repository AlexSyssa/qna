class Answer < ApplicationRecord
  validates :body, presence: true

  belongs_to :question, touch: true
  belongs_to :user

  scope :sort_by_best, -> { order(best: :desc, created_at: :asc) }

  def mark_as_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update(best: true)
    end
  end
end