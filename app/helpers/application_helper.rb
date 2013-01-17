module ApplicationHelper

  def isadmin?
    puts "isadmin: " + current_user.admin?.to_s
    if !current_user.admin?
      redirect_to :controller => :stocks, :action => :index
    end
    current_user.admin?
  end

  def guest_user
    guest = User.where("role = ?", "guest").first
    #guest = User.where("email = ?", "guest@stockton.com").first
    if guest.nil?
      guest = create_guest_user
    end
    guest
  end
  
  def create_guest_user
    attrs = { :email => "guest@stockton.com",
                :password => "abc234",
                :password_confirmation => "abc234",
                :role => "guest" }
    u = User.new(attrs)
    u.save!
    User.where("role = ?", "guest").first
  end

end
