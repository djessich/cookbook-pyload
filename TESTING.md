# Testing the Pyload Cookbook

This document describes the process for testing the Pyload cookbook using the ChefDK.

## Testing Prerequisites

A working ChefDK installation set as your system's default ruby. ChefDK can be downloaded at <https://downloads.chef.io/chef-dk/>

Hashicorp's [Vagrant](https://www.vagrantup.com/downloads.html) and Oracle's [Virtualbox](https://www.virtualbox.org/wiki/Downloads) or [Docker](https://www.docker.com/) for integration testing should also be installed.

## Installing dependencies

Cookbooks may require additional testing dependencies that do not ship with ChefDK directly. These can be installed into the ChefDK ruby environment with the following commands

Install dependencies:

```shell
chef exec bundle install
```

Update any installed dependencies to the latest versions:

```shell
chef exec bundle update
```

## Rakefile

The cookbook contains a Rakefile which includes a number of tasks, each of which can be ran individually, or in groups. Typing *rake* by itself will perform the default checks: style checks (Rubocop/Cookstyle and Foodcritic), unit tests (Chefspec) and integration tests (Kitchen). To see a complete list of available tasks run `chef exec rake -T`.

```bash
$ chef exec rake -T
rake integration:kitchen:all
# ...
rake spec
rake style
rake style:chef
rake style:ruby
rake style:ruby:auto_correct
```

## Style Testing

Ruby style/correctness tests can be performed by Rubocop/Cookstyle by issuing

```shell
chef exec rake style:ruby
```

Chef style/correctness tests can be performed with Foodcritic by issuing

```shell
chef exec rake style:chef
```

## Unit Testing

Unit testing is performed with [ChefSpec](http://sethvargo.github.io/chefspec/). ChefSpec is an extension of Rspec, specially formulated for testing Chef cookbooks. Chefspec compiles your cookbook code and converges the run in memory, without actually executing the changes. The user can write various assertions based on what they expect to have happened during the Chef run. Chefspec is very fast, and quick useful for testing complex logic as you can easily converge a cookbook many times in different ways. All unit tests can be executed by issuing

```shell
chef exec rake spec
```

## Integration Testing

Integration testing is performed by Test Kitchen. Tests should be designed to ensure that a recipe has accomplished its goal. Integration tests can be performed on a local workstation using either VirtualBox or Docker as the virtualization hypervisor. To run tests against all available instances run:

```shell
chef exec kitchen test
```

To see a list of available test instances run:

```shell
chef exec kitchen list
```

To test specific instance run:

```shell
chef exec kitchen test INSTANCE_NAME
```

This cookbook provides a default Kitchen configuration file (kitchen.yml), which performs integration tests using Hashicorp's [Vagrant](https://www.vagrantup.com/downloads.html) and Oracle's [Virtualbox](https://www.virtualbox.org/wiki/Downloads) and a other Kitchen configuration file (kitchen.docker.yml), which performs integration tests using [Docker](https://www.docker.com/).

## Testing Everything

This cookbook provides an easy way of testing Ruby and Chef style/correctness, unit tests and integration tests. This can be performed by issuing the default Rake task

```shell
chef exec rake default
```

This is the recommended way of testing this cookbook.
