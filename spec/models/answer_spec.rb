# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable' do
    let!(:question) { create(:question) }
    let!(:votable) { create(:answer, question: question) }
  end

  it { should belong_to :question }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should have_many_attached(:files) }
  it { should accept_nested_attributes_for :links }
end
