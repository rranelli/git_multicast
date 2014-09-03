# Multicast your git actions.

Have you ever need to clone a whole bunch of repositories? Have you forgot to pull remote changes?

### GitMassDo to the rescue!

`git_mass_do` is a ruby gem that provides a simple `cli` for issuing commands to
multiple git repositories, much like a multicast sends data to multiple
recipients.

`git_mass_do` executes actions in parallel, so cloning 30 repositories will take
just as long as cloning the biggest one, and nothing more.

Actions currently supported:

* Git clone all repositories of an user or organization (github only).
* Git pull all repositories in a directory.

Actions to be supported:

* Git clone repositories from hosts other than github.
* Pass options to git pull.
* Schedule git mass pull
