require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

# this is here to check that we understand the rails default behviour - if this 
# fails then rails has changed wrt multiple calls to same mime type on responder
#
# The default behaviour is that the last call to responder overwrites the previous

class DefaultRespondToController < ActionController::Base
  def foo
    respond_to_without_response_for do |format|
      format.html { first }
      format.html { second }
      format.html { third }
    end
  end
end


describe DefaultRespondToController, ' behaviour of #respond_to' do
  before do
    @controller.stub!(:first)
    @controller.stub!(:second)
    @controller.stub!(:third)
  end
  
  it "get :foo should not call first" do
    @controller.should_not_receive(:first)
    get :foo
  end

  it "get :foo should not call second" do
    @controller.should_not_receive(:second)
    get :foo
  end
  
  it "get :foo should call third" do
    @controller.should_receive(:third).once
    get :foo
  end
end