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
      content_tag(:span, ' Feature', class: 'fa fa-star', title: 'Story Type: Feature')
    when 'bug'
      content_tag(:span, ' Defect', class: 'fa fa-bug', title: 'Story Type: Defect')
    when 'chore'
      content_tag(:span, ' Chore', class: 'fa fa-support', title: 'Story Type: Chore')
    when 'release'
      content_tag(:span, ' Release', class: 'fa fa-flag-checkered', title: 'Story Type: Milestone')
    end
  end

  def requested_by_user?(story)
    Story.exists?(external_ref: story.id)
  end
end
