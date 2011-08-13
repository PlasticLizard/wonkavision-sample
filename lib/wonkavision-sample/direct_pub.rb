module Wonkavision
  module Sample
    class DirectPub
     
      def publish(event_path, event_data)
        event_data = MultiJson.decode(event_data) if event_data.kind_of?(String)
        EM.next_tick do
          Wonkavision.event_coordinator.receive_event(event_path, event_data)
        end
      end
        
    end
  end
end