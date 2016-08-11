#!/usr/bin/env rake

# Style tests. Rubocop and Foodcritic
namespace :style do
  begin
    require 'rubocop/rake_task'
    desc 'Run Ruby style checks'
    RuboCop::RakeTask.new(:ruby)
  rescue LoadError
    puts '>>>>> Rubocop gem not loaded, omitting tasks' unless ENV['CI']
  end

  begin
    require 'foodcritic'

    desc 'Run Chef style checks'
    FoodCritic::Rake::LintTask.new(:chef) do |t|
      t.options = {
        fail_tags: ['any']
      }
    end
  rescue LoadError
    puts '>>>>> foodcritic gem not loaded, omitting tasks' unless ENV['CI']
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# Rspec and ChefSpec
begin
  require 'rspec/core/rake_task'
  desc 'Run ChefSpec examples'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  puts '>>>>> rspec gem not loaded, omitting tasks' unless ENV['CI']
end

# Integration tests. Kitchen.ci
namespace :integration do
  begin
    require 'kitchen/rake_tasks'

    desc 'Run kitchen integration tests'
    Kitchen::RakeTasks.new
  rescue LoadError
    puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
  end
end

# Version tests
begin
  require 'rake/version_task'

  Rake::VersionTask.new do |task|
    task.with_git_tag = true
  end
rescue LoadError
  puts '>>>>> Version gem not loaded, omitting tasks' unless ENV['CI']
end

# Default
desc 'Combines everything together. Run style checks, run ChefSpec examples and run kitchen integration tests.'
task default: ['style', 'spec', 'integration:kitchen:all']
