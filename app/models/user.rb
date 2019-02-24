class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest
  
  validates :name, presence: true, length: {maximum: 50}
  
  # Check the adequacy of the email syntax
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # Better Regex according to Victor: /.*@.*\..*/i
  
  validates :email, presence: true, length: {maximum: 255},
    format: { with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true, length: { minimum: 6}, allow_nil: true
  
  class << self
    
    # Returns the hash digest of the given string
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end  

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end 
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Activates an account
  def activate
    update_attribute(:activated,     true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
    
  private
  
    # Converts email to all lower case
    def downcase_email
      email.downcase!
    end

    # Creates and assigns the activation token and digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
  
end
