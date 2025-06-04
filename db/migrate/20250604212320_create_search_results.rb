class CreateSearchResults < ActiveRecord::Migration[8.0]
  def change
    create_table :search_results do |t|
      t.references :search, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.boolean :favorite, default: false, null: false
    end
  end
end
