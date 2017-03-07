class User < ApplicationRecord
  belongs_to :group
  attr_accessor :password
  attr_readonly :username
  before_create :default_values
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, on: :create
  validates_presence_of :email
  validates_uniqueness_of :email, scope: :group_id
  validates_presence_of :username
  validates_uniqueness_of :username, scope: :group_id
  validates_presence_of :name

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def default_values
    self.balance = 0
    self.api_key = generate_api_key
    self.is_disabled = false

    unless is_admin.present?
      self.is_admin = false
    end
  end

  # # Assign an API key on create
  # before_create do |user|
  #   user.api_key = user.generate_api_key
  # end

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end
end
