# Saxy

Memory-efficient XML parser. Finds object definitions in XML and translates them into Ruby objects.

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
          <images>
            <thumb>http://amazon.com/kindle_thumb.jpg</thumb>
            <large>http://amazon.com/kindle.jpg</large>
          </images>
        </product>
      </products>
    </webstore>

You instantiate the parser by passing path to XML file and object-identyfing tag name as it's arguments.

The following will parse the XML, find product definitions (inside `<product>` and `</product>` tags), build `OpenStruct`s and yield them inside the block:

    Saxy.parse("filename.xml", "product").each do |product|
      puts product.uid # => FFCF177
      puts product.name # => "Kindle"
      puts product.description # => "The world's best-selling e-reader."
      puts product.price # => "$109"

      # nested objects are build as well
      puts product.images.thumb # => "http://amazon.com/kindle_thumb.jpg"
    end

Saxy supports Enumerable, so you can use it's goodies to your comfort without building intermediate arrays:

    Saxy.parse("filename.xml", "product").map do |object|
      # map OpenStructs to ActiveRecord instances, etc.
    end

You can also grab an Enumerator for external use (e.g. lazy evaluation, etc.):

    enumerator = Saxy.parse("filename.xml", "product").each

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
