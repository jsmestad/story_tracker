module ApplicationHelper
  def calculate_risk(estimate)
    case estimate
    when 0
      'none'
    when 1
      'low'
    when 2
      'marginal'
    when 3
      'high'
    else
      'high'
    end
  end

  def story_type_icon(kind)
    case kind
    when 'feature'
      content_tag(:i, nil, class: 'fi-star', title: 'Story Type: Feature')
    when 'bug'
      content_tag(:i, nil, class: 'fi-first-aid', title: 'Story Type: Bug')
    when 'chore'
      content_tag(:i, nil, class: 'fi-widget', title: 'Story Type: Chore')
    when 'release'
      content_tag(:i, nil, class: 'fi-flag', title: 'Story Type: Milestone')
    end
  end

  def requested_by_user?(story)
    Story.exists?(external_ref: story.id)
  end
end
