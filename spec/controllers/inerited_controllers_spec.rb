require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))

class FooAController < FooController
  response_for :foo do |format|
    format.html { a }
  end
end

class FooBController < FooAController
  response_for :foo do |format|
    format.html { b }
  end
end

describe FooAController do
  before do
    @controller.stub!(:a)
  end
  
  it "get :foo should call :b" do
    @controller.should_receive(:a)
    get :foo
  end
end

describe FooBController do
  before do
    @controller.stub!(:b)
  end
  
  it "get :foo should call :b" do
    @controller.should_receive(:b)
    get :foo
  end
end
  