class User < ActiveRecord::Base
  include UserTokenConcern
  include GuidConcern
  include UserRoleConcern
  displayed_with_guid

  has_many :stories, dependent: :destroy, inverse_of: :user

  validates :uid, presence: true, uniqueness: {case_sensitive: false}
  validates :provider, presence: true
  validates :username, presence: true

  validates :email_address, email: {allow_blank: true}

  # attr_encrypted_options.merge!(encode: true)
  attr_encrypted :api_key, key: ENV['USER_APIKEY_KEY']

  validate :api_key_can_access_project

  def self.find_with_omniauth(auth)
    u = self.where(provider: auth['provider'], uid: auth['uid'].to_s).first
    if u and u.username.blank?
      u.update_attribute(:username, auth['info']['nickname'])
    end
    u
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.username = auth['info']['nickname']
        # user.email = auth['info']['email']
        user.name = auth['info']['name'] || ""
      end
    end
  end

  def has_email_address?
    email_address.present?
  end

  def has_api_key?
    api_key.present?
  end

  def connection
    @connection ||= if has_api_key?
                      TrackerProject.new(api_token: api_key)
                    else
                      TrackerProject.new
                    end
  end

protected

  def api_key_can_access_project
    if has_api_key?
      project = TrackerProject.new(api_token: api_key)
      errors.add(:api_key, 'does not have access to the Pivotal Tracker project.') unless project.is_properly_configured?
    end
  end
end
