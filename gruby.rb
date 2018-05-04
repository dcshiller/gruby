#!/usr/bin/env ruby

require 'git'
#require 'byebug'

def g
  @_g = Git.open('./')
end

def add_file
  target_path_matcher = Regexp.new ARGV[1]
  paths = g.status.map(&:path)
  target_path = paths.detect { |path| path =~ target_path_matcher }
  return unless target_path
  g.add target_path
end

def reset_file
  target_path_matcher = Regexp.new ARGV[1]
  paths = g.status.map(&:path)
  target_path = paths.detect do |path|
    #status == 'M' && path =~ target_path_matcher
    path =~ target_path_matcher
  end
  return unless target_path
  g.reset target_path
end

def rebase_to
  comment_matcher = Regexp.new ARGV[1]
  commits = g.log.map { |commit| [commit.message, commit.sha] }.to_h
  commit = commits.map { |k, v| v if k =~ comment_matcher }.compact.first
  g.rebase(commit, interactive: false)
end

operation = ARGV[0]

send(operation)
