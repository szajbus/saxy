# Saxy

[![Gem Version](https://badge.fury.io/rb/saxy.svg)](https://badge.fury.io/rb/saxy)
[![Build Status](https://api.travis-ci.org/monterail/saxy.svg)](http://travis-ci.org/monterail/saxy)

Memory-efficient XML parser. Finds object definitions in XML and translates them into Ruby objects.

It uses SAX parser under the hood, which means that it doesn't load the whole XML file into memory. It goes once through it and yields objects along the way. 

In result the memory footprint of the parser remains small and more or less constant irrespective of the size of the XML file, be it few KB or hundreds of GB.

## Installation

Add this line to your application's Gemfile:

    gem 'saxy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install saxy

As of `0.5.0` version `saxy` requires ruby 1.9.3 or higher. Previous versions of the gem work with ruby 1.8 and 1.9.2 (see below), but they are not maintained anymore.

## Ruby 1.8 support

See `ruby-1.8` branch. Install with:

    gem 'saxy', '~> 0.3.0'

## Ruby 1.9.2 support

See `ruby-1.9.2` branch. Install with:

    gem 'saxy', '~> 0.4.0'


## Usage

Assume the XML file:

````xml
<?xml version='1.0' encoding='UTF-8'?>
<webstore>
  <name>Amazon</name>
  <products>
    <product>
      <name>Kindle - The world's best-selling e-reader.</name>
      <images>
        <thumbSize width="80" height="60">http://amazon.com/kindle_thumb.jpg</thumbSize>
      </images>
    </product>
    <product>
      <name>Kindle Touch - Simple-to-use touchscreen with built-in WIFI.</name>
      <images>
        <thumbSize width="120" height="90">http://amazon.com/kindle_touch_thumb.jpg</thumbSize>
      </images>
    </product>
  </products>
</webstore>
````

You instantiate the parser by passing path to XML file or an IO-like object and object-identyfing tag name as its arguments.

The following will parse the XML, find product definitions (inside `<product>` and `</product>` tags), build `Hash`es and yield them inside the block. 

Usage with a file path:

````ruby
Saxy.parse("filename.xml", "product").each do |product|
  puts product[:name]
  puts product[:images][:thumb_size][:contents]
  puts "#{product[:images][:thumb_size][:width]}x#{product[:images][:thumb_size][:height]}"
end

# =>
"Kindle - The world's best-selling e-reader."
"http://amazon.com/kindle_thumb.jpg"
"80x60"
"Kindle Touch - Simple-to-use touchscreen with built-in WIFI."
"http://amazon.com/kindle_touch_thumb.jpg"
"120x90"
````

Usage with an IO-like object `ARGF`:

````ruby
# > cat filename.xml | ruby this_script.rb
Saxy.parse(ARGF, "product").each do |product|
  puts product.name
end

# =>
"Kindle - The world's best-selling e-reader."
````

Saxy supports Enumerable, so you can use its goodies to your comfort without building intermediate arrays:

````ruby
Saxy.parse("filename.xml", "product").map do |object|
  # map yielded Hash to ActiveRecord instances, etc.
end
````

You can also grab an Enumerator for external use (e.g. lazy evaluation, etc.):

````ruby
enumerator = Saxy.parse("filename.xml", "product").each
lazy       = Saxy.parse("filename.xml", "product").lazy # Ruby 2.0
````

Multiple definitions of child objects are grouped in arrays:

````ruby
webstore = Saxy.parse("filename.xml", "webstore").first
webstore[:products][:product].size # => 2
````

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
