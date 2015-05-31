# Shanty [![Build Status](https://travis-ci.org/shantytown/shanty.svg?branch=master)](https://travis-ci.org/shantytown/shanty) [![Coverage Status](https://coveralls.io/repos/shantytown/shanty/badge.png?branch=master)](https://coveralls.io/r/shantytown/shanty?branch=master) [![Join the chat at https://gitter.im/shantytown/shanty](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/shantytown/shanty)

**Shanty** is a tool orchestrator. You can think of Shanty like make, but self-configuring, modular and useful for tasks that don't necessarily create files. It is designed to make it easy for you to build dependencies between projects, and execute tasks across this tree of relationships, regardless of what language or technology these projects use. The aim is consistency in the way you configure, manage, build, test and deploy your projects.

* Shanty is **language and framework agnostic**. Shanty can configure, build, test and deploy projects or configurations for any language or framework. Shanty config files are written in Ruby for expressiveness.
* Shanty is **self-configuring and pluggable**. Shanty plugins allow projects to be auto-discovered and configured with sensible defaults. Plugins will enrich a project with tasks and configure them such that most people who are following community best practice will find they don't need to write any configuration.
* Shanty **brings all of your tools and utilities together under a unified interface**. It is designed to work with your existing build tools, but allow you to run them all in a orchestrated and unified way.
* Shanty **is great for people with single repository, many subproject setups**. It makes it trivial for you to run a single build, test or deploy command and have it work for all of your subprojects regardless of language or framework.

## What Shanty Does

Lets say you have a project `Service` that builds an artifact. This project has a dependency on the artifact of another  project called `Core`. We want to make a Docker container for the `Service` project.

In order to do this, you need to build the `Core` dependency, then build the `Service` project, and then build the Docker container.

Managing this in existing setups often requires cobbling together shell scripts, configuration files, and the build tools of your choice. Shanty is designed to manage these relationships for you, abstracting the tasks of building and linking these projects into plugins that get auto-triggered based on these relationships.

In this scenario, the relationship between `Core`, `Service` and the Docker container would be discovered, and builds would happen in order with the correct artifacts wired into where they need to be. Triggering this build would be as simple as `shanty build`, and the rest is taken care of for you.

## Using Shanty

### Getting Started

Firstly, you need to install Shanty, which is [available as a gem from RubyGems.org](https://rubygems.org/gems/shanty):

```sh
gem install shanty
```

Then, inside the root of the project directory you want Shanty to manage, run the following to get started:

```sh
shanty init
```

This creates a `.shanty.yml` file, designating this folder as the root of the project tree.

### Stub

Shanty will try to find projects automatically using any Shanty plugins you have installed. The core of Shanty comes with a few built-in plugins:

* `Bundler`: If a `Gemfile` is found anywhere, it will make sure the gems are pulled down and kept up to date when the `build` task is triggered.
* `RSpec`: Detects and runs RSpec tests when the `test` task is triggered.
* `Rubocop`: Detects and runs Rubocop to lint Ruby code when the `test` task is triggered.
* `Rubygem`: Detects a `*.gemspec` file and will build and package a gem when the `build` task is triggered.

To add more plugins, simply create a `Gemfile` in the root of the Shanty tree and add the plugins you would like. The `Bundler` plugin wil

### Built-In Tasks

### Using Plugins

### Writing Plugins

### Per-Project Configuration

## Contributing

We welcome any contribution, whether big or small! Simply raise [GitHub pull requests](/pulls), and we'll collaborate with you! If you need ideas on what to work on, [look at the list of GitHub issues](/issues) or come and talk to us on our [Gitter IM channel](https://gitter.im/shantytown/shanty)!
