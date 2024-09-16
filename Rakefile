#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative "./spec/spec_helper.rb"

RSpec::Core::RakeTask.new(:spec) do |task, args|
	task.rspec_opts = args.to_a[0]
	task.verbose = false
end