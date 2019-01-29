class UserAttributes < ActiveRecord::Migration[5.0]
  def change
    # basic
    add_column :users, :realname, :string
    add_column :users, :nickname, :string, :null => false
    add_column :users, :motto, :string
    add_column :users, :about, :text
    add_column :users, :last_active_at, :datetime

    # references
    add_column :users, :platform_id, :integer, :references => :platforms, :index => true

    # guardian
    add_column :users, :guardian_name, :string
    add_column :users, :guardian_token, :string
    add_column :users, :guardian_token_confirmed_at, :datetime
    add_column :users, :guardian_updated_at, :datetime

    # contacts
    add_column :users, :vkontakte, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :twitch, :string
    add_column :users, :telegram, :string
  end
end
