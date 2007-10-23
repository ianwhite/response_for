require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

describe FooRemovedController do
  it "should not have :foo action" do
    lambda{ get :foo }.should raise_error(ActionController::UnknownAction)
  end
end