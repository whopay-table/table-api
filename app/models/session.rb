class Session < ApplicationRecord
  belongs_to :user
  before_create :default_values

  def self.authenticate(token)
    session = find_by_token(token)
    if session && session.expire_at >= (Time.now + 1.day)
      return session
    elsif session && session.expire_at >= Time.now
      session.expire_at = Time.now + 7.days
      session.save!
      return session
    elsif session
      sessions = Session.where(user_id: session.user_id)
      sessions.select{ |s| s.expire_at < Time.now }.each do |expired_session|
        expired_session.destroy!
      end
      return nil
    else
      return nil
    end
  end

  def self.login(user)
    session = Session.new({ user_id: user.id })
    session.save!
    return session
  end

  def default_values
    self.token = generate_token
    self.expire_at = Time.now + 7.days
  end

  def generate_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless Session.exists?(token: token)
    end
  end
end
