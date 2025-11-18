class CreateEmailSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :email_subscriptions do |t|
      t.string :email

      t.timestamps
    end
    add_index :email_subscriptions, :email, unique: true
  end
end
