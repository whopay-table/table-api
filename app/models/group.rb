class Group < ApplicationRecord
  has_many :users, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  attr_readonly :groupname
  before_create :default_values

  validates_presence_of :groupname
  validates_uniqueness_of :groupname

  def to_json(options={})
    options[:except] ||= [:signup_key]
    options[:include] ||= [:signup_key]
    super(options)
  end

  def default_values
    self.signup_key = generate_signup_key
  end

  def reset_signup_key
    self.signup_key = generate_signup_key
  end

  def set_admin(user)
    current_admin_user = self.users.where(is_admin: true).first
    unless current_admin_user.id == user.id
      current_admin_user.is_admin = false
      user.is_admin = true
      Group.transaction do
        current_admin_user.save!
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
