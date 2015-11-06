module Api
  class BaseResource < ::JSONAPI::Resource
    abstract

    key_type :uuid

    def _primary_key
      :guid
    end
  end
end
