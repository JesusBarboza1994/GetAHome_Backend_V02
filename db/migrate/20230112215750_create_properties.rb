class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.integer :bedrooms
      t.integer :bathrooms
      t.decimal :area
      t.boolean :pet_allowed
      t.integer :price
      t.integer :mode
      t.string :description
      t.integer :property_type
      t.boolean :status
      t.integer :maintenance
      t.string :district
      t.string :province
      t.decimal :latitud
      t.decimal :longitud
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
