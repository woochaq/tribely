class AddWebhookTypeToWebhooks < ActiveRecord::Migration[8.1]
  def change
    add_column :webhooks, :webhook_type, :integer, default: 0, null: false
  end
end
