require 'rails_helper'

RSpec.describe "options/show", type: :view do
  before(:each) do
    @option = assign(:option, Option.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
