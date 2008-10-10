require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

module ResponsesModuleSpec
  module MyActionsAndResponses
    extend Ardes::ResponsesModule
    
    def foo; end
    
    response_for :foo do |format|
      format.html {}
    end
  end
  
  class MyController < ActionController::Base
    include MyActionsAndResponses
  end
  
  describe MyController do
    it "should have action_response for :foo" do
      @controller.class.action_responses['foo'].should_not == nil
    end
    
    it "should have action :foo" do
      @controller.should respond_to(:foo)
    end
  end
end
