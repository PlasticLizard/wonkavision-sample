# require File.dirname(__FILE__) + '/../spec_helper.rb'

# # Time to add your specs!
# # http://rspec.info/
# describe "work_queue_entry_facts" do
#   before(:each) do
#     @input = eval(File.read(File.dirname(__FILE__) +
#                                          '/../test_work_queue_entry_message.rb'))
#     @mapped = Wonkavision::MessageMapper.execute(:work_queue_entry_facts, @input)
#   end

#   it "map the provided input" do
#     @mapped.should_not be_nil
#   end

#   it "should map all inline fields" do
#     %w(id resolution priority current_balance task assigned_to context).each do |field|
#       @mapped[field].should == @input[field]
#     end
#   end

#   it "should map the team" do
#     @mapped["team"]["id"].should == @input["team"]["id"]
#     @mapped["team"]["name"].should == "a-team"
#   end

#   it "should map the status from the resolution" do
#     @mapped["status"]["status"].should == "completed"
#     @mapped["status"]["sort"].should == "4"
#   end

#   it "should map the status from the status when not completed" do
#     @input["completed_time"] = nil
#     @mapped = Wonkavision::MessageMapper.execute(:work_queue_entry_facts, @input)
#     @mapped["status"]["status"].should == "ready"
#     @mapped["status"]["sort"].should == "0"
#   end

#   it "should map the work queue" do
#     @mapped["work_queue"]["id"].should == "4d9cd519ce47d0407100000c"
#     @mapped["work_queue"]["name"].should == "a"
#     @mapped["work_queue"]["priority"].should == 1
#   end

#   it "should map the work queue priority" do
#     @mapped["work_queue_priority"]["priority"].should == 1
#     @mapped["work_queue_priority"]["name"].should == "Priority 1"
#   end

#   it "should map the company data" do
#     @mapped["company"].should == { "company_id" => @input["company_id"]}
#   end

#   it "should replace null assigned to with Unknown" do
#     @input["assigned_to"] = nil
#     @mapped = Wonkavision::MessageMapper.execute(:work_queue_entry_facts, @input)
#     @mapped["assigned_to"]["id"].should == "Unknown"
#     @mapped["assigned_to"]["name"].should == "Unknown"
#   end

#   describe "dates" do
#     [["due_date","due_date"],
#      ["overdue_date","overdue_date"],
#      ["started_time", "started_date"],
#      ["completed_time","completed_date"]].each do |date|
#       describe date do
#         it "should be map each date component" do
#           d = @mapped[date[1]]
#           indate = @input[date[0]]
#           indate = Time.parse(indate) if indate
#           d["timestamp"].should == indate
#           d["day_key"].should == indate.iso8601[0..9] if indate
#           d["month_key"].should == indate.iso8601[0..6] if indate
#           d["year_key"].should == indate.year.to_s if indate
#           d["day_of_month"].should == indate.day if indate
#           d["day_of_week"].should == indate.wday if indate
#           d["month"].should == indate.month if indate
#         end
#       end
#     end
#   end

# end
