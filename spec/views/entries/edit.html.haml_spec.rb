require 'spec_helper'

describe "entries/edit" do
  before(:each) do
    @entry = assign(:entry, stub_model(Entry,
      :title => "MyString",
      :body => "MyText",
      :blog_id => 1
    ))
  end

  it "renders the edit entry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", entry_path(@entry), "post" do
      assert_select "input#entry_title[name=?]", "entry[title]"
      assert_select "textarea#entry_body[name=?]", "entry[body]"
      assert_select "input#entry_blog_id[name=?]", "entry[blog_id]"
    end
  end
end
