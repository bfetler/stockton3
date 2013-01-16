module ApplicationHelper
  def isadmin?
    puts "isadmin: " + current_user.admin?.to_s
    if !current_user.admin?
      redirect_to :controller => :stocks, :action => :index
    end
    current_user.admin?
#   true
  end

  def guest_user
#   guest = User.where("role = ?", "guest").first
    guest = User.where("email = ?", "guest@stockton.com").first
#   guest = User.where("role = ?", "goon").first  # testing
#   create if nil?
    if guest.nil?   # validation fails if email already taken
puts "yup, guest is nil"
      pars = {:email => "guest@stockton.com", :password => "abc234", :password_confirmation => "abc234", :role => "guest"}
      u = User.new(pars)
      u.save!
      guest = User.where("role = ?", "guest").first
    end
    guest
  end

end
