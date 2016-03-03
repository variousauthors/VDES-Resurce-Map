require 'rails_helper'

RSpec.describe "services/index", type: :view do
  before(:each) do
    assign(:services, [
      Service.create!(),
      Service.create!()
    ])
  end

  it "renders a list of services" do
    render
  end
end
