require 'spec_helper'

describe Saxy do
  include FixturesHelper

  it "should find object definitions in XML file and yield them as Ruby objects" do
    products = Saxy.parse(fixture_file("webstore.xml"), "product").inject([]) do |arr, product|
      arr << product
      arr
    end

    expect(products[0]["uid"]).to eq("FFCF177")
    expect(products[0]["name"]).to eq("Kindle")
    expect(products[0]["description"]).to eq("The world's best-selling e-reader.")
    expect(products[0]["price"]).to eq("$109")
    expect(products[0]["images"]["thumb"]).to eq("http://amazon.com/kindle_thumb.jpg")
    expect(products[0]["images"]["large"]).to eq("http://amazon.com/kindle.jpg")

    expect(products[1]["uid"]).to eq("YD26NT")
    expect(products[1]["name"]).to eq("Kindle Touch")
    expect(products[1]["description"]).to eq("Simple-to-use touchscreen with built-in WIFI.")
    expect(products[1]["price"]).to eq("$79")
    expect(products[1]["images"]["thumb"]).to eq("http://amazon.com/kindle_touch_thumb.jpg")
    expect(products[1]["images"]["large"]).to eq("http://amazon.com/kindle_touch.jpg")
  end

  it "should group multiple definitions of child objects into arrays" do
    webstore = Saxy.parse(fixture_file("webstore.xml"), "webstore").first

    expect(webstore["products"]["product"]).to be_an(Array)
    expect(webstore["products"]["product"].size).to eq(2)
  end

  it "should return Enumerator when calling #parse without a block" do
    expect(Saxy.parse(fixture_file("webstore.xml"), "product").each).to be_an(Enumerator)
  end

  it "should pass options to Parser's initializer" do
    expect(Saxy::Parser).to receive(:new).with("filename", "object_tag", { foo: 'bar' }).and_call_original
    Saxy.parse("filename", "object_tag", { foo: 'bar' })
  end
end
