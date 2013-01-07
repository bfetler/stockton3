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
    session[:guest_login]
  end

  def current_user_or_guest
    res = current_user
    if res.nil?
puts "res was nil"
      guest = User.where("role = ?", "guest").first
puts "session(cg): " + session.to_s
      if session[:guest_login] and guest.is_a? User
        res = guest
      end
    end
    res
  end

  def authenticate_user_or_guest
    res = false
    if current_user.nil?
      guest = User.where("role = ?", "guest").first
puts "session(cg): " + session.to_s
      if session[:guest_login] and guest.is_a? User
        res = true
      end
    else
      authenticate_user!
    end
  end

end
