# frozen_string_literal: true

class AddBestToAnswer < ActiveRecord::Migration[7.1]
  def change
    add_column :answers, :best, :boolean, default: false
  end
end
