# require "time"
# require "date"

# module Rpm
#   class WorkQueueEntryFacts
#     include Wonkavision::Analytics::Facts

#     record_id :id

#     accept "work_queue_entry/deleted", :action => :reject do
#       string :id
#     end

#     accept "work_queue_entry/updated", :action => :update do
#       import :work_queue_entry_facts
#     end

#     def self.status_sort_key(status)
#       ["ready","expires_today", "overdue","in_progress","completed","completed_today","cancelled","scheduled","unknown"].index(status)
#     end

#     snapshot :daily
    
#     dynamic :work_queue_entry_dynamic
      
#   end
# end

module Wonkavision
	module Sample
		class TestFacts
			include Wonkavision::Analytics::Facts

			record_id :id

		end
	end
end
