require 'spec_helper'

describe Saxy::OpenStruct do
  let(:object) { Saxy::OpenStruct.new }

  it "should correctly set id attribute" do
    object.id = 1
    object.id.should == 1
  end
end
