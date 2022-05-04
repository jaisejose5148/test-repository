class User < ApplicationRecord
  has_secure_password
  #mount_uploader :avatar, AvatarUploader
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }


   def self.generate_jwt_token(user_id)  
   token = JWT.encode({ id: user_id,
   exp: 60.days.from_now.to_i },
   Rails.application.secrets.secret_key_base)
   token
 end
      
end