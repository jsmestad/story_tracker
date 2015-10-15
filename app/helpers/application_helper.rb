module ApplicationHelper
  def calculate_risk(estimate)
    case estimate
    when 0
      'none'
    when 1
      'low'
    when 2
      'medium'
    when 3
      'high'
    else
      'high'
    end
  end

  def story_type_icon(kind)
    case kind
    when 'feature'
      content_tag(:span, nil, class: 'fa fa-star', title: 'Story Type: Feature') + 'Feature'
    when 'bug'
      content_tag(:span, nil, class: 'fa fa-bug', title: 'Story Type: Defect') + "Defect"
    when 'chore'
      content_tag(:span, nil, class: 'fa fa-support', title: 'Story Type: Chore') + "Chore"
    when 'release'
      content_tag(:span, nil, class: 'fa fa-flag-checkered', title: 'Story Type: Milestone') + "Release"
    end
  end

  def requested_by_user?(story)
    Story.exists?(external_ref: story.id)
  end
end
