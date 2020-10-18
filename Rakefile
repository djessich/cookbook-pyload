#!/usr/bin/env rake
task default: %w(clean doc style test)

desc 'Clean this Cookbook'
task :clean do
  %w(
    Berksfile.lock
    .bundle
    .cache
    coverage
    Gemfile.lock
    .kitchen
    metadata.json
    vendor
    policies/*.lock.json
    commit.txt
    rspec.xml
    .yardoc
    doc
  ).each { |f| FileUtils.rm_rf(Dir.glob(f)) }
end

desc 'Generate all documentation for this cookbook'
task doc: ['doc:yard']
namespace :doc do
  require 'yard'
  desc 'Generate documentation with YARD for this cookbook'
  YARD::Rake::YardocTask.new do |t|
    t.stats_options = %w(--list-undoc)
  end
end

desc 'Run all style checks on this Cookbook'
task style: ['style:foodcritic', 'style:cookstyle']
namespace :style do
  require 'foodcritic'
  desc 'Run style checks with Foodcritic on this Cookbook'
  FoodCritic::Rake::LintTask.new(:foodcritic) do |task|
    task.options = {
      fail_tags: ['any'],
      progress: true,
    }
  end

  require 'cookstyle'
  require 'rubocop/rake_task'
  desc 'Run style checks with Cookstyle on this Cookbook'
  RuboCop::RakeTask.new(:cookstyle) do |task|
    task.options << '--display-cop-names'
    task.options << '--extra-details'
  end
end

desc 'Run all unit and integration tests on this Cookbook'
task test: ['test:unit', 'test:kitchen:all']
namespace :test do
  require 'rspec/core/rake_task'
  desc 'Run unit tests with ChefSpec on this Cookbook'
  RSpec::Core::RakeTask.new(:unit)

  require 'kitchen/rake_tasks'
  desc 'Run integration tests with Kitchen on this Cookbook'
  Kitchen::RakeTasks.new
end
