class CreateAwards < ActiveRecord::Migration[7.1]
  def change
    create_table :awards do |t|
      t.string :name, null: false
      t.string :image, null: false
      t.references :user, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
