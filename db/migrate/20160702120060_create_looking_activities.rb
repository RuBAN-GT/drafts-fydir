class CreateLookingActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :looking_activities do |t|
      t.string :slug, null: false

      t.timestamps
    end
  end
end
