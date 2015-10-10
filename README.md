# pm
The easy way to switch to your projects on Shell. Add your projects to `pm` and switch between them with a command. 

## Installation
To install the program, download the installer and execute it.

```zsh
cd ~
wget https://raw.githubusercontent.com/Angelmmiguel/pm/master/install.sh
chmod 755 ./install.sh
```

If you want to install last stable version, only run downloaded script:

```zsh
./install.sh
```

If you want to install latest development version, run the installer with `--prerelease` option: 

```zsh
./install.sh --prerelease
```

Type your shell when the installer ask to you:

```zsh
What is your shell? [ zsh, bash ]: 
```

### Update PM

To update PM, run same process than installation and say `yes` when PM ask you to update.

## Shells
Available shells are:
* ZSH
* Bash (Prerelease, you need to run installer with `--prerelease` option)

## Usage
Move to your awesome project and add it to `pm`:

```zsh
cd projects/awesome-project
pm add awesome-project
```

Try to add another. Next, list stored projects:

```zsh
pm list
# awesome-project
# another-project
```

To switch into a project, use `pm go`:

```zsh
pm go awesome-project
# Current project: awesome-project
```

If a project is not longer available, remove it:

```zsh
pm remove another-project
pm list
# awesome-project
```

# Config

## Global

PM allow some config values. To add, edit or remove a config parameter:

```zsh
pm config <add|get|remove> <parameter> (value)
```

Available config parameters:
* `after-all` : execute this command after switch to a project with `pm go`.
* `git-info` : show a resume of Git when `go` to a project.

For example, you can open Sublime Text on a project when `go` to it:

```zsh
pm config add after-all "sublime ."
```

## Projects

With PM you can add configuration to projects. To add, edit or remove a config parameter of a project:

```zsh
pm config-project <project> <add|get|remove> <parameter> (value)
```

Available config parameters:
* `after` : execute this command after switch to the project with `pm go`.
* `git-info` : show a resume of Git status.

For example, you can start [Gulp](http://gulpjs.com/) in a project when `go` to it:

```zsh
pm config-project myproject add after "gulp"
```

# Example

![Example of PM in a gif](https://raw.githubusercontent.com/Angelmmiguel/pm/master/pm.gif)

# Contribute

To contribute `pm`:

* Create an issue with the contribution: bug, enhancement..
* Fork the project and edit it
* Create a pull request when you finish

# License
PM is released under the MIT license. Copyright [@Laux_es](https://twitter.com/Laux_es) ;)