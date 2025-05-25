class CreateProteins < ActiveRecord::Migration[7.2]
  def change
    create_table :proteins do |t|
      t.string :name
      t.text :description
      t.string :brand
      t.integer :price
      t.float :protein_content
      t.integer :weight
      t.string :flavor

      t.timestamps
    end
  end
end
