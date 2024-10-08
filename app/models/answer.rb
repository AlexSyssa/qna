class Answer < ApplicationRecord
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question, touch: true
  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc, created_at: :asc) }

  def mark_as_best
    transaction do
      self.class.where(question_id: question_id).update_all(best: false)
      update(best: true)
      question.award&.update!(user_id: self.user_id)
    end
  end
end
