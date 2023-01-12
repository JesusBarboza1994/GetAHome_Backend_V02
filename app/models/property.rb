class Property < ApplicationRecord
  has_one_attached :image
  has_many :involved_properties, dependent: :destroy
  belongs_to :user

end
