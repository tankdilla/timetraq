require 'spec_helper'

describe "projects/edit" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "MyString",
      :description => "MyString",
      :start_time => "",
      :days => 1,
      :hours => 1
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path(@project), :method => "post" do
      assert_select "input#project_name", :name => "project[name]"
      assert_select "input#project_description", :name => "project[description]"
      assert_select "input#project_start_time", :name => "project[start_time]"
      assert_select "input#project_days", :name => "project[days]"
      assert_select "input#project_hours", :name => "project[hours]"
    end
  end
end
