class CreateSupplements < ActiveRecord::Migration[7.2]
  def change
    create_table :supplements do |t|
      t.string :name
      t.text :description
      t.string :brand
      t.integer :price
      t.string :category
      t.string :effects
      t.string :dosage

      t.timestamps
    end
  end
end
