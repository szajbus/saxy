# Saxy

Memory-efficient XML parser. Finds object definitions and translates them into Ruby objects.

It uses SAX parser under the hood, which means that it doesn't load the whole XML file into memory. It goes once though it and yields objects along the way.

## Installation

Add this line to your application's Gemfile:

    gem 'saxy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install saxy

## Usage

Assume the XML file:

    <?xml version='1.0' encoding='UTF-8'?>
    <webstore>
      <name>Amazon</name>
      <products>
        <product>
          <uid>FFCF177</uid>
          <name>Kindle</name>
          <description>The world's best-selling e-reader.</description>
          <price>$109</price>
        </product>
      </products>
    </webstore>

And a Ruby class:

    class Product
      attr_accessor :uid, :name, :description, :price
    end

The following will parse the XML, find product definitions (inside `<product>` and `</product>` tags), build instances of Product class and yield them inside the block:

    Saxy.parse("filename.xml", "product" => Product).each do |product|
      # Do something creative with the product (save to database, etc.)
    end

You can detect more than one type of object during single parsing. Simply pass more matchers (tag name => Ruby class pairs). Unfortunately you can only pass one block, so you need to differentiate objects inside it yourself.

    Saxy.parse("filename.xml", "product" => Product, "webstore" => Shop).each do |object|
      case object
      when Product
        # It's a Product
      when Shop
        # It's a Shop
      end
    end

Saxy doesn't support (yet) nested structures, so you'd get Shop instances with name only and no nested products.

### But I need more features, my classes are complex, schemaless and don't directly map to XML structure!

Take the simplest approaches of all: use OpenStructs and map (yes, Saxy includes Enumerable) them to your own classes.

    require 'ostruct'
    Saxy.parse("filename.xml", "product" => OpenStruct).map do |object|
      # Extract value and currency from object.price, etc...
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
