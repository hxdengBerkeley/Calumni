require "rails_helper"

describe People do
  let (:testlet) {1}
  before :each do
    @people = People.new
  end

  it "should respond to test" do
    expect { Object.new.unknown_method }.to raise_error(NoMethodError)
  end
end
