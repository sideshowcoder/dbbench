#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber/rake/task"

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty --tags ~@cassandra"
end

namespace :setup do
  desc "print sql for setting up mysql"
  task :mysql do
    puts "CREATE DATABASE dbbench_test;"
    puts "CREATE TABLE dbbench_test.somethings(id INT(10), foo VARCHAR(255), data VARCHAR(255);"
  end

  desc "print sql for setting up cassandra"
  task :cassandra do
    puts "CREATE KEYSPACE demo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };"
    puts "CREATE_COLUMNFAMILY things (thing_id uuid PRIMARY_KEY, data varchar);"
  end
end

task :cucumber => :features

