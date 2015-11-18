module Api
  class StoryResource < BaseResource
    attributes :title, :description, :story_type, :external_ref

    relationship :user, to: :one, foreign_key_on: :related, foreign_key: :guid

    def title
      @model.name
    end
  end
end
