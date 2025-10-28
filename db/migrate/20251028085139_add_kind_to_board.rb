class AddKindToBoard < ActiveRecord::Migration[8.1]
  def change
    add_column :boards, :kind, :integer, default: 0
  end
end
