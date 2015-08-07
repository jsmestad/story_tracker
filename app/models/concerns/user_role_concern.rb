module UserRoleConcern
  extend ActiveSupport::Concern

  included do
    enum role: {viewer: 0, regular_user: 1, admin: 2}
    after_initialize :set_default_role, if: :new_record?

    scope :admin, -> { where(role: User.roles[:admin]) }
    scope :viewer, -> { where(role: User.roles[:viewer]) }
  end

  def set_default_role
    self.role ||= :viewer
  end
end
