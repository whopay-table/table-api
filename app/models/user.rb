class User < ApplicationRecord
  belongs_to :group
  has_many :transactions
  has_many :sessions
  attr_accessor :password
  before_create :default_values
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, on: :create
  validates_presence_of :email
  validates_uniqueness_of :email, scope: :group_id
  validates_presence_of :name

  def self.authenticate(group_id, email, password)
    user = find_by(group_id: group_id, email: email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.salt)
      return user
    else
      return nil
    end
  end

  def reset_password
    password = SecureRandom.hex(12)
    self.update_attribute(:password, password)
    self.save
    return password
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def default_values
    self.balance = 0
    self.is_disabled = false

    unless is_admin.present?
      self.is_admin = false
    end
  end
end
