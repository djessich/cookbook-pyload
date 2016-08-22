# Testing the Pyload Cookbook

This document describes the process for testing the Pyload cookbook using the ChefDK. Cookbooks can be tested using the test dependencies defined in the cookbooks Gemfile alone, but that process will not be covered in this document in order to maintain simplicity.

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

The cookbook contains a Rakefile which includes a number of tasks, each of which can be ran individually, or in groups. Typing *rake* by itself will perform the default checks: style checks (Rubocop/Cookstyle and Foodcritic), unit tests (Chefspec) and integration tests (Kitchen). To see a complete list of available tasks run `rake -T`

```bash
$ chef exec rake -T
rake integration:kitchen:all
rake spec
rake style
rake style:chef
rake style:ruby
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

## Spec Testing

Unit testing is done by running Rspec examples. Rspec will test any libraries, then test recipes using ChefSpec. This works by compiling a recipe (but not converging it), and allowing the user to make assertions about the resource_collection. The tests can be performed by issuing

```shell
chef exec rake spec
```

## Integration Testing

Integration testing is performed by Test Kitchen. After a successful converge, tests are uploaded and ran out of band of Chef. Tests should be designed to ensure that a recipe has accomplished its goal. The tests can be performed by issuing

```shell
chef exec rake integration:kitchen:all
```

This cookbook provides a default Kitchen configuration file (kitchen.yml), which performs integration tests using Hashicorp's [Vagrant](https://www.vagrantup.com/downloads.html) and Oracle's [Virtualbox](https://www.virtualbox.org/wiki/Downloads) and an other Kitchen configuration file (kitchen.docker.yml), which performs integration tests using [Docker](https://www.docker.com/).

## Testing Everything

This cookbook provides an easy way of testing Ruby and Chef style/correctness, unit tests and integration tests. This can be performed by issuing the default Rake task

```shell
chef exec rake default
```

This is the recommended way of testing this cookbook.
