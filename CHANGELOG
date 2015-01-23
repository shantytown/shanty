# Changelog

## v0.2.0 (22nd January, 2015)

* **Change tracking:** Added working changed flags to projects to allow CLI tasks to run just on projects that are different since last time. Note that this is a work in progress, as there are lots of things to still work on here (for example, it's currently implemented as a mutator, and it saves the change index even if the CLI command doesn't end up using it or fails to run).
* **Env class:** Added Env class to allow passing around of config, paths and other stuff separate to the TaskEnv (which contains the graph). An env instance is available to all mutators and discovers. TaskEnv is just a decorator of Env, so you can continue to call the methods you used to on it where you only have TaskEnv available (eg. in a task)!
* **Removed VCS/Git Code:** Now that we have change support that doesn't need a VCS, all of the VCS and Git stuff has been removed. This was all internal for now anyway, so shouldn't effect anybody. However, this does mean you can now use Shanty in any directory, rather than it having to be a VCS repository of some sort.
