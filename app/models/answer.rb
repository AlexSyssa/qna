class Answer < ApplicationRecord
  validates :body, presence: true

  belongs_to :question, touch: true
  belongs_to :user
end