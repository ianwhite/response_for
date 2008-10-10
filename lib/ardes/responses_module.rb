module Ardes#:nodoc:
  # Extension to facilitate writing responses in mixins
  #
  # extend this into your own module to have it act as a response_for namespace
  # when this module is included into a controller, the responses will be copied
  # over, along with the actions.
  #
  # Example:
  #
  #  module MyActions
  #    extend Ardes::ResponsesModule
  #
  #    def foo
  #      do_foo
  #    end
  #
  #    response_for :foo do |format|
  #      format.html { # do a response }
  #    end
  #  end
  #
  #  class AController < ApplicationController
  #    include MyActions
  #    # now this controller has foo and response_for :foo
  #  end
  module ResponsesModule
    include ResponseFor::ClassMethods
    
    def self.extended(mixin)
      class << mixin
        def included_with_responses(controller_class)
          action_responses.each do |action, responses|
            controller_class.action_responses[action] ||= []
            controller_class.action_responses[action].unshift(responses)
          end
        end
        alias_method_chain :included, :responses
      end
    end
  end
end