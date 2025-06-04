class CreateSearchesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :searches do |t|
      t.text :tags
      t.string :city, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.boolean :favorite, null: false, default: false
      t.timestamps
    end
  end
end
