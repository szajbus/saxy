# Saxy Changelog

## 0.7.0

* [BREAKING] Yielded hashes now have strings as keys instead of symbols (performance and security fix).

## 0.6.1

* Fixed passing options from `Saxy.parse` to parser's initializer

## 0.6.0

* [BREAKING] `Saxy::ParsingError` now inherits from `StandardError`, not `Exception`.
* [BREAKING] Forced encoding is now an option instead of third argument of `Saxy.parse` method.
* Added `recovery` and `replace_entities` options that are internally passed to `Nokogiri::XML::SAX::ParserContext`
* Added `context` method to `Saxy::ParsingError` that holds parser context at the time of error.

## 0.5.2

* Added optional `encoding` argument to `Saxy.parse`

## 0.5.1

* Removed `activesupport` dependency

## 0.5.0

* [BREAKING] Dropped support for ruby 1.9.2 and lower
* [BREAKING] Yields hashes instead of `OpenStruct`s
* Added support for `IO`-like objects
