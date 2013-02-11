require 'spec_helper'

describe Saxy::OpenStruct do
  let(:object) { Saxy::OpenStruct.new }

  if Saxy.ruby_18?
    context "in Ruby 1.8" do
      it "should correctly set id attribute" do
        object.id = 1
        object.id.should == 1
      end
    end
  end
end
