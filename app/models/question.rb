class Question < ApplicationRecord

  has_one :award,          dependent: :destroy
  has_many :answers,       dependent: :destroy
  has_many :links,         dependent: :destroy, as: :linkable

  has_many_attached :files

  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true
end
