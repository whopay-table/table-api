class Group < ApplicationRecord
  has_many :users
  attr_accessor :password
  attr_readonly :groupname
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

  def set_admin(user)
    curr_admin_user = self.users.where(is_admin: true).first
    unless curr_admin_user.id == user.id
      curr_admin_user.is_admin = false
      user.is_admin = true
      Group.transaction do
        curr_admin_user.save!
        user.save!
      end
    end
  end
end
