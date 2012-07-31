require 'spec_helper'

describe "entries/new" do
  before(:each) do
    assign(:entry, stub_model(Entry,
      :note => "MyString",
      :score => 1
    ).as_new_record)
  end

  it "renders new entry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => entries_path, :method => "post" do
      assert_select "input#entry_note", :name => "entry[note]"
      assert_select "input#entry_score", :name => "entry[score]"
    end
  end
end
