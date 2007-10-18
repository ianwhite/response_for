class FooBarController < ApplicationController
  def foo
    @foo = "Foo"
    respond_to do |format|
      format.html {}
    end
  end
  
  def bar
    @bar = "Bar"
  end
end

class XmlFooBarController < FooBarController
  response_for :foo, :bar do |format|
    format.xml {}
  end
end

class XmlOnlyFooBarController < FooBarController
  response_for :foo, :bar, :replace => true do |format|
    format.xml {}
  end
end

class XmlAndMoreFooBarController < XmlFooBarController
  response_for :foo do |format|
    format.rjs do 
      render :update do |page|
        page.replace_html 'foo', 'Foo'
      end
    end
  end
  
  response_for :bar do |format|
    format.html { render :action => 'more_bar' }
  end
end

class FooRemovedController < FooBarController
  remove_action :foo
end

class FooBarRemovedController < FooBarController
  remove_action :foo, :bar
end