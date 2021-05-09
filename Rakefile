#!/usr/bin/env rake

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
