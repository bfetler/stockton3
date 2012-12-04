module ApplicationHelper
  def isadmin?
    current_user.admin?
#   true
  end
end
