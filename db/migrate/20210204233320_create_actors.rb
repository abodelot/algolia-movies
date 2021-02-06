class CreateActors < ActiveRecord::Migration[6.1]
  def change
    create_table :actors do |t|
      t.string :name, null: false
      t.string :image, null: false
      t.timestamps

      t.index :name, unique: true
    end
  end
end
