require "spec_helper"
require "wonkavision-sample/api_utils"

describe ApiUtils do

  context "#query_from_params" do
    before :each do
      @params = {
        "columns" => "a|b",
        "rows" => "c|d ", 
        "pages" => ["e","f"],
        "chapters" => ["g","h"],
        "sections" => ["i","j"],
        "measures" => ["k","l"],
        "filters" => [:dimensions.a.caption.eq(2).to_s, :measures.k.ne("b").to_s].join("|")
      }
      @query = ApiUtils.query_from_params(@params)

    end
    
    it "should extract dimensions into each named axis" do
      (0..4).each do |axis_ordinal|
        ["columns","rows","pages","chapters","sections"].each_with_index do |axis,idx|
          @query.axes[idx].should == ApiUtils.parse_list(@params[axis])
        end
      end
    end

    it "should extract measures" do
      @query.measures.should == @params["measures"]
    end

    it "should extract each filter" do
      @query.filters.length.should == 2
    end

    it "should convert strings to MemberFitler" do
      @query.filters.each do |f|
        f.should be_a_kind_of(Wonkavision::Analytics::MemberFilter)
      end
    end

    it "should properly parse each filter" do
      @query.filters[0].member_type.should == :dimension
      @query.filters[0].operator.should == :eq
      @query.filters[0].value.should == 2
      @query.filters[0].attribute_name.should == 'caption'

      @query.filters[1].member_type.should == :measure
      @query.filters[1].operator.should == :ne
      @query.filters[1].value.should == "b"
      @query.filters[1].attribute_name.should == 'count'
    end
  end

  context "facts_query_from_params" do
    before :each do
      @params = {
        "filters" => [:dimensions.a.caption.eq(2).to_s, :measures.k.ne("b").to_s].join("|"),
        "page" => "2",
        "per_page" => "50",
        "sort" => "a:1|b:-1"
      }
      @filters, @options = ApiUtils.facts_query_from_params(@params)
    end
    it "should extract each filter" do
      @filters.length.should == 2
    end

    it "should convert strings to MemberFitler" do
      @filters.each do |f|
        f.should be_a_kind_of(Wonkavision::Analytics::MemberFilter)
      end
    end

    it "should extract the options" do
      @options[:page].should == 2
      @options[:per_page].should == 50
      @options[:sort].should == [["a",1],["b",-1]]
    end
  end

  context "parse_list" do
    it "should return nil if the input is blank" do
      ApiUtils.parse_list("").should be_nil
    end
    it "should return an array if the input is an array" do
      ApiUtils.parse_list([1,2,3]).should == [1,2,3]
    end
    it "should return a single element array if the input is a single string" do
      ApiUtils.parse_list("a").should == ["a"]
    end
    it "should split a string by commas if the input is a comma string" do
      ApiUtils.parse_list("a| b |   c   ").should == ["a","b","c"]
    end
  end

  context "parse_sort_list" do
    it "should parse a string representing a list of sort criteria into a two dimensional array" do
      ApiUtils.parse_sort_list("a:1|b:-1").should == [["a",1],["b",-1]]
    end
  end

end
