class FooController < ApplicationController
  def foo
    @foo = "Foo"
    respond_to do |format|
      format.html {}
    end
  end
  
  # testing that erase_render_results works as expected
  def bar
    respond_to(:json)
    erase_render_results
  end
end

class XmlFooController < FooController
  response_for :just_a_template, :foo, :bar, :types => [:xml]
end

class FooBailOutController < FooController
  before_filter :bail_out_if_redirect
  
  response_for :foo do |format|
    format.html { render :action => 'cool'}
  end
  
protected
  def bail_out_if_redirect
    if params[:redirect]
      respond_to_without_response_for do |format|
        format.html { redirect_to 'http://test.host/redirected' }
      end
    end
  end
end

class InlineXmlFooController < FooController
  response_for :foo do |format|
    format.xml do
      render :inline => xml_call(action_name) # to be stubbed in specs
    end
  end
end

class XmlOnlyFooController < FooController
  response_for :foo, :bar, :types => [:xml], :replace => true
end

class BackToFooController < XmlFooController
  remove_response_for :foo, :bar
end

class FooRemovedController < FooController
  remove_action :foo
  
  def foo2; end
  def foo3; end
end

class AllFooRemovedController < FooRemovedController
  remove_action :foo2, :foo3
end