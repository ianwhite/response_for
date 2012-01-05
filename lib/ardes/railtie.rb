module ResponseFor
  class Railtie < Rails::Railtie #:nodoc:
    initializer 'ardes.response_for' do
      ActiveSupport.on_load(:action_controller) do
        include Ardes::ResponseFor
      end      
    end
  end
end