require 'rubygems'
require 'bundler/setup'
require 'saxy'

require 'fixtures_helper'
require File.join(File.dirname(__FILE__), 'fixtures', 'io_like')

RUBY_1_8 = (RUBY_VERSION =~ /^1\.8/)