# Changelog

## v0.3.0

* **--watch is no more:** It was never a good fit within Shanty itself: we don't have global options, and it doesn't fit well as a plugin. We recommend you use an external tool that does this, of which there are many (filewatcher, nodemon, and many others).
* **Graph#projects_within_path:** A convenience method for getting all the projects from the given path downwards. Useful for getting a list of the projects a task may need to run on when it uses the current working directory for determining such things.
* **TaskEnv at instance scope for Tasks:** Previously, all tasks had to take in the `options` and `task_env` arguments followed by any params. Now, they just take `options`, followed by any params; `task_env` is available as an attribute on the `TaskSet` class.

## v0.2.0 (22nd January, 2015)

* **Change tracking:** Added working changed flags to projects to allow CLI tasks to run just on projects that are different since last time. Note that this is a work in progress, as there are lots of things to still work on here (for example, it's currently implemented as a mutator, and it saves the change index even if the CLI command doesn't end up using it or fails to run).
* **Env class:** Added Env class to allow passing around of config, paths and other stuff separate to the TaskEnv (which contains the graph). An env instance is available to all mutators and discovers. TaskEnv is just a decorator of Env, so you can continue to call the methods you used to on it where you only have TaskEnv available (eg. in a task)!
* **Removed VCS/Git Code:** Now that we have change support that doesn't need a VCS, all of the VCS and Git stuff has been removed. This was all internal for now anyway, so shouldn't effect anybody. However, this does mean you can now use Shanty in any directory, rather than it having to be a VCS repository of some sort.
