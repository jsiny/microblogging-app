class User < ApplicationRecord

  # Make sure that emails are saved without capital letters
  before_save {email.downcase!}
  validates :name, presence: true, length: {maximum: 50}
  
  # Check the adequacy of the email syntax
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # Better Regex according to Victor: /.*@.*\..*/i
  
  validates :email, presence: true, length: {maximum: 255},
    format: { with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password
  
  validates :password, presence: true, length: { minimum: 6}
end
