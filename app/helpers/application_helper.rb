module ApplicationHelper

  # create text with an icon to the left for bootstrap menus and buttons
  def text_with_icon(text, icon_name)
    raw("#{icon(icon_name)} #{text}")
  end

  def text_with_image(text, icon_name, html_class)
    raw("#{image_tag("tags/#{ icon_name.parameterize.underscore }.jpg", class: html_class)} #{text}")
  end

  # generate a standard bootstrap glyphicon
  def icon(name)
    content_tag(:span, nil, class: "glyphicon glyphicon-#{name}")
  end

  # action name to use for the primary submit button on scaffold-created CRUD forms
  def btn_action_prefix
    case action_name
      when 'new', 'create'
        'Create'
      when 'edit', 'update'
        'Update'
      else
        nil
    end
  end

  # bootstrap icon name to use for the primary submit button on scaffold-created forms
  def action_icon_name
    case action_name
      when 'new', 'create'
        'plus'
      when 'edit', 'update'
        'edit'
      else
        nil
    end
  end

  def alert_class(alert_type)
    alert_type = {
      alert: 'danger',
      notice: 'info'
    }.with_indifferent_access.fetch(alert_type, alert_type.to_s)
    "alert-#{alert_type}"
  end

  def tag_icon_name(tag)
    case tag.downcase
    when 'shelter'
      'home'
    when 'health'
      'plus'
    when 'food'
      'cutlery'
    when 'showers'
      'cloud'
    end
  end

  def category_icon_name(category)
    case category.downcase
    when 'shelter'
      'home'
    when 'health'
      'plus'
    when 'food'
      'cutlery'
    end
  end
end
