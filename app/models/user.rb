class User < ApplicationRecord

  # Validations

  # Associations
  has_many :involved_properties, dependent: :destroy
  has_many :properties, through: :involved_properties, counter_cache: true
  # type 1 - landlord , type 2 - buyer
  enum user_type: { landlord: 1, seeker: 2 }
  # Authentication methods
  before_create do
    self.token_created_at = Time.current
  end
  
  has_secure_password
  has_secure_token

  def invalidate_token
    update(token: nil, token_created_at: nil)
  end

  def update_token
    regenerate_token
    update(token_created_at: Time.current)
  end

end
