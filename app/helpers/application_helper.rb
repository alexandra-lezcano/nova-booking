module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def link_to_add_fields(name, f, association, room_facilities)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize , f: builder, room_facilities: room_facilities)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def get_score_color(range)
    colors = %w(danger warning success)
    case range
    when 0..3
      colors.first
    when 4..8
      colors.second
    else
      colors.third
    end
  end
end
