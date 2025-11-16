class AddSlugToDocument < ActiveRecord::Migration[8.1]
  def change
    add_column :documents, :slug, :string
  end
end
