# module Rpm
#   class WorkQueueStatus
#     include Wonkavision::Analytics::Aggregation

#     aggregates WorkQueueEntryFacts

#     filter do |facts|
#       facts["is_active"] == true &&
#       facts["status"]["status"] !~ /cancelled/
#     end

#     dimension :team do
#       key :id
#       caption :name
#       sort :name
#     end

#     dimension :status do
#       key :status
#       sort :sort
#     end

#     dimension :assigned_to do
#       key :id
#       caption :name
#       sort :name
#     end

#     dimension :work_queue_priority do
#       key :key
#       sort :priority
#       caption :name
#     end

#     dimension :work_queue do
#       key :id
#       caption :name
#       sort :priority
#     end

   
#     snapshot :daily

#     measure :count
#     sum :incoming, :outgoing, :completed, :overdue, :expiring_today, :pending

#     aggregate_by :team
#     aggregate_by :team, :work_queue
#     aggregate_by :team, :work_queue, :work_queue_priority
#     aggregate_by :work_queue_priority

#     aggregate_by :team, :status
#     aggregate_by :team, :work_queue, :status
#     aggregate_by :team, :work_queue_priority, :work_queue, :status
#     aggregate_by :work_queue_priority, :status
#   end
# end

module Wonkavision
	module Sample
		class TestAggregation
			include Wonkavision::Analytics::Aggregation

			aggregates TestFacts

		end
	end
end