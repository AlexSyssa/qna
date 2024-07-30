# frozen_string_literal: true
class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    if current_user.author?(@attachment.record)
      @attachment.purge
      redirect_to request.referer || root_path, notice: 'Attachment was successfully deleted.'
    else
      flash[:alert] = "You can't delete another's attachment!"
    end
  end
end
