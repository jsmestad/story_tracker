class StorySerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :description, :href

  url :story

  def id
    object.to_param
  end

  def href
    story_path(object)
  end
end
