require 'spec_helper'

describe "tags/new" do
  before(:each) do
    assign(:tag, stub_model(Tag,
      :description => "MyString",
      :classification => "MyString"
    ).as_new_record)
  end

  it "renders new tag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tags_path, :method => "post" do
      assert_select "input#tag_description", :name => "tag[description]"
      assert_select "input#tag_classification", :name => "tag[classification]"
    end
  end
end
