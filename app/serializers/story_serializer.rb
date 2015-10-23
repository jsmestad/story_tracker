class StorySerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::DateHelper
  attributes :id, :name, :description, :href, :latest_description

  url :story

  attributes :versions

  def id
    object.to_param
  end

  def versions
    object.versions.reverse.collect do |version|
      {
        id: version.index,
        comment: version.comment || '',
        created_at: "#{time_ago_in_words(version.created_at)} ago"
      }
    end
  end

  def href
    story_path(object)
  end
end
