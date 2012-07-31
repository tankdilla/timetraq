require 'spec_helper'

describe "tags/edit" do
  before(:each) do
    @tag = assign(:tag, stub_model(Tag,
      :description => "MyString",
      :classification => "MyString"
    ))
  end

  it "renders the edit tag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tags_path(@tag), :method => "post" do
      assert_select "input#tag_description", :name => "tag[description]"
      assert_select "input#tag_classification", :name => "tag[classification]"
    end
  end
end
