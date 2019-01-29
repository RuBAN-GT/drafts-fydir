class CreateConversationMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :conversation_members do |t|
      t.references :user, index: true
      t.references :conversation, index: true
      
      t.boolean :parted, :null => false, :default => true
      t.boolean :viewed, :null => false, :default => true

      t.timestamps
    end
  end
end
