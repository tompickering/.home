# .home

This allows you to maintain your home environment in a git repository without requiring your home directory itself to be a repo. It allows you to look after your ubiquitous dotfiles in a dedicated directory, and provides a script which will create symlinks to these at the same relative path with repect to ~. Using this, clean home environment deployments into new systems are a breeze!

## Installation and Usage

Simply clone this repo into ~/.home, move your dotfiles (and any other home elements you'd like to keep under version control, such as your ~/bin directory or parts thereof) into ~/.home/linkins, and finally run ~/.home/deploy_home.sh. No link will be created if a file already exists at the target destination - these will be reported. This script will end by creating a helpful symlink to itself in ~/bin (also creating this if it doesn't already exist).

Note that:
- The 'leaf' files, rather than directories, are symlinked. This means that you can maintain files under (e.g.) ~/config in VCS whilst preventing other applications from writing into your VCS-controlled directories.
- On future runs of deploy_home.sh, all symlinks will first be removed and then recreated. Any directories left empty during this process will also be cleared up, keeping your filesystem nice and tidy if you ever remove or relocate any deep-nested files.

## Ideas

Now that you have a helpful ~/.home directory to keep things tidy in, there are a few other useful ways in which it can be used. For example, if your shell .rc file is becoming somewhat bloated, why not extract meaningful chunks (such as alias definitions) out into separate files under ~/.home/shell and have your main file source them all in? I find it's also handy to maintain a script under .home which installs all of my favourite Debian packages.


This repo is designed to be forked! Create a clone and maintain it on your git server of choice :)
