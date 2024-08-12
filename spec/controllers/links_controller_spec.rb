# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:other_user) { create(:user) }
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      it "destroys user's own link" do
        login(user)

        expect { delete :destroy, params: { id: link } }.to change(question.links, :count).by(-1)
      end

      it "doesn't destroy another's link" do
        login(other_user)

        expect { delete :destroy, params: { id: link } }.not_to change(question.links, :count)
      end

      it 'renders destroy view' do
        login(user)
        delete :destroy, params: { id: link }

        expect(response).to render_template :destroy
      end
    end

    context 'Unauthenticated user' do
      it "doesn't destroy another's link" do
        expect { delete :destroy, params: { id: link } }.not_to change(question.links, :count)
      end
    end
  end
end
