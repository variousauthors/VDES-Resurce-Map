require 'rails_helper'

RSpec.describe "services/new", type: :view do
  before(:each) do
    assign(:service, Service.new())
  end

  it "renders new service form" do
    render

    assert_select "form[action=?][method=?]", services_path, "post" do
    end
  end
end
