module OwnersHelper

  def current_owner
    @current_owner ||= Owner.find_by(user_id: current_user.id)
  end

  def is_owner?
    current_owner != nil
  end

  def user_email(user_id)
    User.find_by_id(user_id).email
  end

end
