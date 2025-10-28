class RemoveNameFromBoard < ActiveRecord::Migration[8.1]
  def change
    remove_column :boards, :name, :string
  end
end
