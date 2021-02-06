class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title, null: false, index: true
      t.string :alternative_titles, array: true, default: [], null: false
      t.string :genres, array: true, default: [], null: false
      t.integer :year, null: false
      t.string :image, null: false
      t.string :color # NULL: missing value in records.json
      t.float :score, null: false
      t.integer :rating, null: false
      t.timestamps
    end

    create_table :actors_movies do |t|
      t.references :actor, foreign_key: true
      t.references :movie, foreign_key: true
    end
  end
end
