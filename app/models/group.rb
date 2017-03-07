class Group < ApplicationRecord
  has_many :users
  attr_readonly :groupname
  before_create :default_values

  validates_presence_of :groupname
  validates_uniqueness_of :groupname

  def default_values
    self.signup_key = generate_signup_key
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

  # Generate a unique sign up key
  def generate_signup_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless Group.exists?(signup_key: token)
    end
  end
end
