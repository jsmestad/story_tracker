class User < ActiveRecord::Base
  has_many :stories, dependent: :destroy, inverse_of: :user

  validates :uid, presence: true, uniqueness: {case_sensitive: false}
  validates :provider, presence: true

  def self.find_with_omniauth(auth)
    self.where(provider: auth['provider'], uid: auth['uid'].to_s).first
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
      end
    end
  end
end
