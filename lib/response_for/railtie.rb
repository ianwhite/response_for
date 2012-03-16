module ResponseFor
  class Railtie < Rails::Railtie #:nodoc:
    initializer 'response_for' do
      ActiveSupport.on_load(:action_controller) do
        include ResponseFor::ActionController
      end      
    end
  end
end