require 'rails_helper'

RSpec.describe "options/index", type: :view do
  before(:each) do
    assign(:options, [
      Option.create!(),
      Option.create!()
    ])
  end

  it "renders a list of options" do
    render
  end
end
