class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :body, :null => false

      t.references :user, index: true
      t.references :conversation, index: true, null: false

      t.timestamps
    end
  end
end
