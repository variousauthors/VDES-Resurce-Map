require 'rails_helper'

RSpec.describe "services/show", type: :view do
  before(:each) do
    @service = assign(:service, Service.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
