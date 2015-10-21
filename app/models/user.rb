class User < ActiveRecord::Base

  validates :user_name, :password_digest, :session_token, presence: true
  validates :session_token, uniqueness: true
  validates :password, length: { minimum: 6 }

  def self.generate_session_token
    token = SecureRandom.urlsafe_base64
    while User.exists?(session_token: token)
      token = SecureRandom.urlsafe_base64
    end
    token
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
  end

  def password
    @password
  end

  def password=(new_password)
    # @password = BCrypt::Password.create(new_password)
    # self.password_digest = @password
    @password = new_password
    self.password_digest = BCrypt::Password.create(new_password)
  end

  def is_password?(input_pass)
    BCrypt::Password.new(self.password_digest).is_password?(input_pass)
  end

  def self.find_by_credentials(user_name, input_pass)
    user = User.find_by_user_name(user_name)

    if user && user.is_password?(input_pass)
      user
    else
      nil
    end
  end

  private
    def ensure_session_token
      self.session_token ||= self.generate_session_token
    end


end
