require "wonkavision-sample/direct_pub"

import "wonkavision"

Wonkavision.event_coordinator.job_queue = Wonkavision::Sample::DirectPub.new
#import "amqp"




