class CreatePlatforms < ActiveRecord::Migration[5.0]
  def change
    create_table :platforms do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps null: false
    end
  end
end
