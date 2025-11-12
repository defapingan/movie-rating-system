class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :category
      t.string :country
      t.integer :release_year
      t.decimal :average_rating
      t.text :description

      t.timestamps
    end
  end
end
