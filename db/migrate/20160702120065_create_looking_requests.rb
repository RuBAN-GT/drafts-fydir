class CreateLookingRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :looking_requests do |t|
      t.text :description
      t.string :looking_type, default: 'group', null: false
      t.boolean :microphone, null: false, default: false
      t.integer :min_light
      t.string :experience, default: 'every', null: false
      t.timestamps null: false

      # references
      t.references :user, index: true
      t.references :platform, index: true
      t.references :looking_activity, index: true
    end
  end
end
