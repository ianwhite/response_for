module Ardes #:nodoc:
  module ResponseFor
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        alias_method_chain :default_render, :response_for
      end
    end
    
    module ClassMethods
      # response_for allows you to specify a default response for your actions that don't specify a
      # respond_to block.
      # 
      # Using response_for, you may keep the response logic out of the action, so that it can be overriden easily
      # without having to rewrite the entire action.  This is very useful when subclassing controllers.
      #
      # == Usage
      #
      #   response_for :action1 [, :action2], [,:types => [:mime, :type, :list]] [ do |format| ... end] # or
      #   response_for :action1 [, :action2], [,:type => :mime_type] [ do |format| ... end]
      #
      # === Example
      #
      #   class FooController < ApplicationController
      #     def index
      #       @foos = Foo.find(:all)
      #     end
      #   
      #     def show
      #       @foo = Foo.find(params[:id])
      #     end
      #   end
      #   
      #   # this controller needs to respond_to fbml on index, and
      #   # js, html and xml (templates) on index and show
      #   class SpecialFooController < FooController
      #     response_for :index do |format|
      #       format.fbml { render :inline => turn_into_facebook(@foos) }
      #     end
      #   
      #     response_for :index, :show, :types => [:html, :xml, :js]
      #   end
      #
      # === respond_to takes precedence
      # 
      # If you write your action with a respond_to block, response_for will never be invoked for that action.
      # If you want to write a controller so that its subclasses can use response_for then do this:
      #
      #   # before
      #   def show
      #     @thing = Thing.find(params[:id])
      #     respond_to do |format|
      #       format.html { }
      #       format.xml  { render :xml => @thing }
      #     end
      #   end
      # 
      #   # after
      #   def show
      #     @thing = Thing.find(params[:id])
      #   end
      #
      #   response_for :show do |format|
      #     format.html { }
      #     format.xml  { render :xml => @thing }
      #   end
      # 
      # === Other examples 
      #
      #   response_for :index, :types => [:fbml]    # index will respond to fbml and try to render, say, index.fbml.builder
      #
      #   response_for :update do |format|          # this example is for a resources_controller controller
      #     if !(resource.new_record? || resource.changed?) # => resource.saved?
      #       format.js { render(:update) {|page| page.replace(dom_id(resource), :partial => resource}}
      #     else
      #       format.js { render(:update) {|page| page.visual_effect :shake, dom_id(resource) }}
      #     end
      #   end
      #
      # === Notes
      #
      # * If the before_filters or action renders or redirects, then response_for will not be invoked
      # * you can stack up multiple response_for calls, the most recent has precedence
      # * the specifed block is executed within the controller instance, so you can use controller
      #   instance methods and instance variables (i.e. you can make it look just like a regular
      #   respond_to block)
      # * you can add a response_for an action that is just a public template (where there is no
      #   actual action method defined)
      # * you can combine the :types option with a block, the block has precedence if you specify the
      #   same mime type in both.
      def response_for(*actions, &block)
        (options = actions.extract_options!).assert_valid_keys(:types)
        
        types_block = if options[:types]
          proc {|responder| Array(options[:types]).each {|type| responder.send type}}
        end
        
        # store responses against action names
        actions.collect(&:to_s).each do |action|
          action_responses[action] ||= []
          action_responses[action].unshift types_block if types_block
          action_responses[action].unshift block if block
          
          # if there's no action yet defined, create a stub - this is so that you
          # can provide responses for actions which are simply templates, or simply define responses
          class_eval "def #{action}; end" unless instance_methods.include?(action)
        end
      end
    
      # remove any response for the specified actions.  If no arguments are given, the
      # entire all repsonses for all actions are removed
      def remove_response_for(*actions)
        if actions.empty?
          instance_variable_set('@action_responses', nil)
        else
          actions.each {|action| action_responses.delete(action.to_s)}
        end
      end
      
      # return action_responses Hash. On initialize, set and return hash whose values are copies of superclass action_responses, if any
      def action_responses
        instance_variable_get('@action_responses') || instance_variable_set('@action_responses', copy_of_each_of_superclass_action_responses)
      end
      
    private
      def copy_of_each_of_superclass_action_responses
        (superclass.action_responses rescue {}).inject({}){|m,(k,v)| m.merge(k => v.dup)}
      end
    end
    
  protected
    def respond_to_action_responses
      if (responses = self.class.action_responses[action_name]) && responses.any?
        respond_to do |responder|
          responses.each do |response|
            instance_exec(responder, &response)
          end
        end
      end
    end
    
    def default_render_with_response_for
      respond_to_action_responses
      default_render_without_response_for unless performed?
    end
  end
end