require 'spec_helper'

describe ApplicationHelper do
  
  it "creates a guest user" do
    guest = create_guest_user
    guest.should_not be_nil
  end
  
  it "returns a guest user" do
    guest_user.should_not be_nil
  end
  
end