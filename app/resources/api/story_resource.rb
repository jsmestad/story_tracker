module Api
  class StoryResource < BaseResource
    attributes :title, :description, :story_type, :external_ref

    has_one :user

    def title
      @model.name
    end
  end
end
