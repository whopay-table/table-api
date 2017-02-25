class Group < ApplicationRecord
  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :groupname
  validates_uniqueness_of :groupname

  def self.authenticate(groupname, password)
    group = find_by_groupname(groupname)
    if group && group.password_hash == BCrypt::Engine.hash_secret(password, group.salt)
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
end
