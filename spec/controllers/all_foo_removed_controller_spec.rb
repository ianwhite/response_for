require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

describe AllFooRemovedController do
  it "should not have :foo action" do
    lambda{ get :foo }.should raise_error(ActionController::UnknownAction)
  end
    
  it "should not have :foo2 action" do
    lambda{ get :foo2 }.should raise_error(ActionController::UnknownAction)
  end
  
  it "should not have :foo3 action" do
    lambda{ get :foo3 }.should raise_error(ActionController::UnknownAction)
  end
end