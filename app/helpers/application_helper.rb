module ApplicationHelper
  def isadmin?
    puts "isadmin: " + current_user.admin?.to_s
    if !current_user.admin?
      redirect_to :controller => :stocks, :action => :index
    end
    current_user.admin?
#   true
  end

  def isguest?
#   session[:guest_login]
    if user_signed_in?
      current_user.role == "guest"
    else
      false
    end
  end

  def guest_user
    guest = User.where("role = ?", "guest").first
#   create if nil?
  end

end
