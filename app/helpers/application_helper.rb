module ApplicationHelper
  def isadmin?
    puts "isadmin: " + current_user.admin?.to_s
    if !current_user.admin?
      redirect_to :controller => :stocks, :action => :index
    end
    current_user.admin?
#   true
  end

  def current_user_or_guest
    res = current_user
    if res.nil?
puts "res was nil"
      guest = User.where("role = ?", "guest").first
#     if session[:guest_login] and guest.any?
        res = guest
#     end
    end
    res
  end

end
