module GuidConcern
  extend ActiveSupport::Concern

  included do
    before_validation :set_guid!, on: :create, if: :has_guid_concern?
    validate :guid_concern_validator, if: :has_guid_concern?
  end

  module ClassMethods
    def displayed_with_guid(options={})
      column_name = options[:column_name] || "guid"

      singleton_class.instance_eval do
        define_method(:find_by_guid) do |guid|
          where(:"#{column_name}" => guid).first or raise ActiveRecord::RecordNotFound
        end
      end

      class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def to_param
          self.#{column_name}
        end

        def guid_column
          #{column_name}
        end

        def has_guid_concern?
          true
        end

        def set_guid!
          self.#{column_name} = SecureRandom.uuid
        end

        def guid_concern_validator
          errors.add(:#{column_name}, :blank) if self.#{column_name}.blank?
        end
      RUBY
    end
  end

  def has_guid_concern?
    false
  end
end
