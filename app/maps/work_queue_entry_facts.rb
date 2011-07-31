Wonkavision::MessageMapper.register :test_facts do
	value :id
end
# Wonkavision::MessageMapper.register :work_queue_entry_facts do

#   value :id, :resolution, :priority, :current_balance,
#   :task, :assigned_to, :context


#   string :resolution => Rpm::Analytics.ensure_val(context["resolution"], "queued")

#   child :team => context["team"] do
#     string :id, :name
#   end

#   child :work_queue => context["work_queue"] do
#     string :id, :name
#     integer :priority
#   end

#   child :work_queue_priority => context["work_queue"] do
#     integer :priority
#     string :name => "Priority #{priority}"
#     string :key => priority.to_s
#   end

#   child :status => context do
#     string :status => if context["completed_time"]
#       Rpm::Analytics.ensure_val(context["resolution"],"unknown")
#     else
#       Rpm::Analytics.ensure_val(context["current_status"], "unknown")
#     end
#     string :sort => Rpm::WorkQueueEntryFacts.status_sort_key(status)
#   end

#   child :company => context do
#     string :company_id
#   end

#   child :assigned_to => context["assigned_to"] || {} do
#     string :id => Rpm::Analytics.ensure_val(context["id"], "Unknown")
#     string :name => Rpm::Analytics.ensure_val(context["name"], "Unknown")
#   end

#   child :created_date => context["created_at"] do
#     time :timestamp => context ? Time.parse(context).localtime : context
#     string :day_key => timestamp.iso8601[0..9]
#   end

#   child :due_date => context["due_date"] do
#     time :timestamp => context
#     string :day_key => timestamp.iso8601[0..9]
#     string :month_key => timestamp.iso8601[0..6]
#     string :year_key => timestamp.year
#     int :day_of_month => timestamp.day
#     int :day_of_week => timestamp.wday
#     int :month => timestamp.month
#     #string :label => context.rfc822[0..15]
#   end

#   child :overdue_date => context["overdue_date"] do
#     time :timestamp => context
#     string :day_key => timestamp.iso8601[0..9]
#     string :month_key => timestamp.iso8601[0..6]
#     string :year_key => timestamp.year
#     int :day_of_month => timestamp.day
#     int :day_of_week => timestamp.wday
#     int :month => timestamp.month
#     #string :label => context.rfc822[0..15]
#   end

#   child :started_date => context["started_time"] do
#     time :timestamp => context ? Time.parse(context).localtime : context
#     string :day_key => timestamp.iso8601[0..9]
#     string :month_key => timestamp.iso8601[0..6]
#     string :year_key => timestamp.year
#     int :day_of_month => timestamp.day
#     int :day_of_week => timestamp.wday
#     int :month => timestamp.month
#     #string :label => context.rfc822[0..15]
#   end

#   child :completed_date => context["completed_time"] do
#     time :timestamp => context ? Time.parse(context).localtime : context
#     string :day_key => timestamp.iso8601[0..9]
#     string :month_key => timestamp.iso8601[0..6]
#     string :year_key => timestamp.year
#     int :day_of_month => timestamp.day
#     int :day_of_week => timestamp.wday
#     int :month => timestamp.month
#     #string :label => context.rfc822[0..15]
#   end

# end
