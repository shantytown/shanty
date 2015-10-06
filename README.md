# Shanty [![Build Status](https://travis-ci.org/shantytown/shanty.svg?branch=master)](https://travis-ci.org/shantytown/shanty) [![Coverage Status](https://coveralls.io/repos/shantytown/shanty/badge.svg?branch=master&service=github)](https://coveralls.io/github/shantytown/shanty?branch=master)

**Shanty is a tool orchestrator.** You can think of Shanty like Make, but self-configuring and modular. It is designed to make it easy for you to build dependencies between projects, and execute tasks across this tree of relationships, regardless of what language or technology these projects use. The aim is consistency in the way you configure, manage, build, test and deploy everything.

* Shanty is **language and framework agnostic**. Shanty can configure, build, test and deploy projects or configurations for any language or framework. Shanty config files are written in Ruby for expressiveness and flexibility, allowing you to work with any tool you can imagine.
* Shanty is **self-configuring and pluggable**. Shanty plugins allow projects to be auto-discovered and configured with sensible defaults. Plugins will enrich a project with tasks and configure them such that most people who are following community best practice will find they don't need to write any configuration. However, everything is configurable and you can override these defaults as you need.
* Shanty **brings all of your tools and utilities together under a unified set of commands**. It is designed to work with your existing build tools, but allow you to run them all in a orchestrated and unified way.
* Shanty **is great for people with single repository, many subproject setups**. It makes it trivial for you to run a single build, test or deploy command and have it work for all of your subprojects regardless of language or framework.

## What Shanty Does

Lets say you have a project `Service` that builds an artifact. This project has a dependency on the artifact of another  project called `Core`. We want to make a Docker container for the `Service` project.

In order to do this, you need to build the `Core` dependency, then build the `Service` project, and then build the Docker container.

Managing this in existing setups often requires cobbling together shell scripts, configuration files, and the build tools of your choice. Shanty is designed to manage these relationships for you, abstracting the tasks of building and linking these projects into plugins that get auto-triggered based on these relationships.

In this scenario, the relationship between `Core`, `Service` and the Docker container would be discovered automatically, and builds would happen in order with the correct artifacts wired into where they need to be. Triggering this build would be as simple as `shanty build`, and the rest is taken care of for you.

## Using Shanty

### Getting Started

Firstly, you need to install Shanty, which is [available as a gem from RubyGems.org](https://rubygems.org/gems/shanty):

```sh
gem install shanty
```

You'll need [a copy of the latest stable Rust compiler installed](https://www.rust-lang.org/) (we use this to speed up certain parts of Shanty).

Then, inside the root of the project directory you want Shanty to manage, run the following to get started:

```sh
shanty init
```

This creates a `Shantyconfig` file, designating this folder as the root of the project tree.

### Plugins

The core of Shanty relies on plugins to find your projects and execute functionality across them.

There are a few built-in plugins that Shanty comes with:

* `Bundler`: If a `Gemfile` is found anywhere, it will run `bundle install` when the `build` task is triggered.
* `Cucumber`: Detects and runs Cucumber tests when the `test` task is triggered.
* `RSpec`: Detects and runs RSpec tests when the `test` task is triggered.
* `Rubocop`: Detects and runs Rubocop to lint Ruby code when the `test` task is triggered.
* `Rubygem`: Detects a `*.gemspec` file and will build and package a gem when the `build` task is triggered.

To enable a plugin, require it in your `Shantyconfig`:

```ruby
# Here's an example of enabling the RSpec plugin:
require 'shanty/plugins/rspec_plugin'
```

If it's a plugin that's not built-in to Shanty, you'll need to add a dependency on it in your `Gemfile` as well.

### Tasks

The other aspect of Shanty is tasks. Tasks either perform some action, trigger plugins to perform some actions, or both.

Again, just like with the plugins, there are some built-in tasks:

* `init`: Designates the current directory as the root of the Shanty project. Any plugins will look for projects from this point recursively into any folders.
* `plugins`: Lists all the plugins currently enabled.
* `plugin`: Shows the help for a specific plugin, including listing the tasks a plugin listens to. Run with `shanty help --name <plugin>`, eg. `shanty help --name bundler`.
* `build`: Triggers any plugins that know how to build to do so.
* `test`: Triggers any plugins that know how to test to do so.
* `deploy`: Triggers any plugins that know how to "deploy" to do so.

To run any of these tasks, it's simple:

```sh
shanty <task>
```

If you need some information on running tasks, you can view the help:

```sh
shanty help # Help for Shanty itself
shanty help <task> # Help for a specific task
```

### Writing Plugins & Tasks

### Configuration

## Contributing

We welcome any contribution, whether big or small! Simply raise [GitHub pull requests](/pulls), and we'll collaborate with you! If you need ideas on what to work on, [look at the list of GitHub issues](/issues).
