class Property < ApplicationRecord
  has_one_attached :image
  has_many :involved_properties, dependent: :destroy
  belongs_to :user
  enum mode: { sale: 1, rent: 2 }
  enum property_type: { house: 1, apartment: 2 }
  # mode 1: for sale, mode 2: for rent
end
