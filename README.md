# Shanty [![Build Status](https://travis-ci.org/shantytown/shanty.svg?branch=master)](https://travis-ci.org/shantytown/shanty) [![Coverage Status](https://coveralls.io/repos/shantytown/shanty/badge.png?branch=master)](https://coveralls.io/r/shantytown/shanty?branch=master)

**Shanty** is a project orchestration tool. It is designed to make it easy for you to build dependencies between projects, and execute tasks across this tree of relationships, regardless of what language or technology these projects use. The aim is consistency in the way you manage, build, test and deploy your projects.

* Shanty is **language agnostic**. Shanty config files must be written in Ruby, but can be written for any type of project written in any language.
* Shanty **is not a build tool**. It is designed to work with your existing build tool, instead living a layer up where it manages tasks to call to your build tool.
* Shanty **is great for people with single repository, many subproject setups**. It makes it trivial to use your repository with many well known Continuous Integration tools and get benefits like building only changed projects, and depedency management.
* Shanty **supports plugins**. You can hook into the lifecycle of Shanty at any point to achieve the task you want. Plugins can discover projects, add support for a new VCS, add actions that will be executed when a command is run, and work out whether a project has changed or not based on more complex dependencies.

## Why Would I Want To Use Shanty Instead Of `<Insert Build Tool Here>`?

Shanty is designed to make it easy to run tasks consistently across projects of many different types or written in many different languages.

A great example use case of Shanty is integrating with Docker:

```
Foo (Java) -> Bar (Java) -> Bar Container (Docker)
```

Lets say you have a Java project `Bar` that builds an artifact. This Java project has a dependency on the artifact of another Java project called `Foo`. In order to dockerise the `Bar` project, you need to build the `Foo` dependency, then build the `Bar` project, and then build the Docker container.

Managing this in existing setups often requires cobbling together shell scripts and the build tool of your choice. Shanty is designed to manage these relationships for you, abstracting the tasks of building and linking these projects into plugins that get auto-triggered based on these relationships (think `make`). Projects like `Gradle` go a long way towards supporting this model with their multi-project support, but the expressiveness of Ruby is missed as soon as you need to do something menial like read in a JSON options file for a project.

So, with Shanty, building the Docker container would be as simple as `shanty build` in the Docker container project folder, and the rest is taken care of for you. This is because Shanty is designed to give you the freedom to choose any tool for any project, written in any language, by allowing you to plug in functionality where you need it.

## Contibuting

We welcome any contribution, whether big or small! We're busy importing our planned work as GitHub issues so people can join in the fun, we also have a [Huboard](https://huboard.com/shantytown/shanty) to make following the progress easier. If you have any questions, please hit us up on our freenode IRC channel `#shantytown`.

## License

The MIT License (MIT)

Copyright (c) 2015 Chris Jansen, Nathan Kleyn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
