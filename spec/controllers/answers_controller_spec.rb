# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:votable) { create(:answer, question: question) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer), question_id: question,
                         format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) },
                        format: :js
        end.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answers atributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        end.to_not change(answer, :body)
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer, user: user, question: question }

    context 'User is the author of the answer' do
      it 'Author deletes the answer from database' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question/show' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "User isn't the author of the answer" do
      before { login(other_user) }
      it 'User tries to delete the answer from database' do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'redirects to root_path' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #upvote' do
    context 'when the user is not the author' do
      it 'votes up for the votable' do
        expect { post :upvote, params: { id: votable.id } }.to change { votable.votes.count }.by(1)

        expect(flash[:notice]).to eq('You voted!')
      end
    end

    context 'when the user is the author' do
      before { votable.update(user: user) }

      it 'renders an error' do
        post :upvote, params: { id: votable.id }

        expect(response.body).to include("You can't vote on your own content")
      end
    end
  end

  describe 'GET #downvote' do
    context 'when the user is not the author' do
      it 'votes down for the votable' do
        expect { post :downvote, params: { id: votable.id } }.to change { votable.votes.count }.by(1)

        expect(flash[:notice]).to eq('You voted!')
      end
    end

    context 'when the user is the author' do
      before { votable.update(user: user) }

      it 'renders an error' do
        post :downvote, params: { id: votable.id }

        expect(response.body).to include("You can't vote on your own content")
      end
    end
  end

  describe 'POST #cancel' do
    context 'when the user is not the author' do
      before { votable.upvote(user) }

      it 'cancels the vote for the votable' do
        expect { post :cancel, params: { id: votable.id } }.to change { votable.votes.count }.by(-1)

        expect(flash[:notice]).to eq('Your vote successfully updated')
      end
    end

    context 'when the user is the author' do
      before { votable.update(user: user) }

      it 'renders an error' do
        post :cancel, params: { id: votable.id }

        expect(response.body).to include("You can't vote on your own content")
      end
    end
  end
end
