class CreateInvolvedProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :involved_properties do |t|
      t.references :user, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.boolean :favorite
      t.boolean :contacts

      t.timestamps
    end
    add_index :involved_properties, [:user_id, :property_id], unique: true
  end
end
