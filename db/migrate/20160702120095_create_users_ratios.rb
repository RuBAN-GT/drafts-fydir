class CreateUsersRatios < ActiveRecord::Migration[5.0]
  def change
    create_table :users_ratios do |t|
      t.integer :point

      t.references :user, :index => true
      t.references :voted, :references => :users, :index => true

      t.timestamps
    end
  end
end
