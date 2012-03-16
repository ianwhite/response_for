require 'spec_helper'

module ErrorInTemplateSpec
  class TestController < ApplicationController
    response_for :action_rendering_erroneous_template do |format|
      format.html { render :action => 'error_in_template' }
    end
    
    def action_rendering_erroneous_template
    end
  end

  describe TestController do
    render_views
    
    it "GET :action_rendering_erroneous_template should raise \"Boom!\"" do
      lambda { get :action_rendering_erroneous_template }.should raise_error("Boom!")
    end
  end
end