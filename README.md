[![Build Status](https://travis-ci.org/rranelli/git_multicast.svg?branch=0.1.0)](https://travis-ci.org/rranelli/git_multicast)
[![Gem Version](https://badge.fury.io/rb/git_multicast.svg)](http://badge.fury.io/rb/git_multicast)
[![git_multicast API Documentation](https://www.omniref.com/ruby/gems/git_multicast.png)](https://www.omniref.com/ruby/gems/git_multicast)

# Multicast your git actions.

Have you ever need to clone a whole bunch of repositories? Have you forgot to pull remote changes?

### git_multicast to the rescue!

`git_multicast` is a ruby gem that provides a simple `cli` for issuing commands to
multiple git repositories, much like a multicast sends data to multiple
recipients.

`git_multicast` executes actions in parallel, so cloning 30 repositories will take
just as long as cloning the larger one, and nothing more.

Actions currently supported:

* Git clone all repositories of an user or organization (github & bitbucket).

```sh
git_multicast clone username
```

* Git pull all repositories in a directory.

```sh
git_multicast clone username
```

* Git status all repositories in a directory.

```sh
git_multicast status
```


* Sends a custom git command to all repositories in a directory.

```sh
git_multicast cast "push --force origin master" # don't do this at home.
```

All actions allow for both `--verbose` and `--quiet` options that will control
how much output is shown for each command execution.

Actions to be supported:

* Git clone repositories from `Gitlab`.
