#!/usr/bin/env ruby

require 'git'
require 'byebug'

def g
  Git.open('./')
end

def add_file
  target_path_matcher = Regexp.new ARGV[1]
  paths = g.status.map(&:path)
  target_path = paths.detect { |path| path =~ target_path_matcher }
  g.add target_path
end

def reset_file
  target_path_matcher = Regexp.new ARGV[1]
  paths = g.status.map(&:path)
  target_path = paths.detect { |path| status = 'M' && path =~ target_path_matcher }
  g.reset target_path
end

operation = ARGV[0]

send(operation)
