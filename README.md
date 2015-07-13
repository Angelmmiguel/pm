# pm
The easy way to switch to your projects on ZSH. Add your projects to `pm`and switch between them with a command. 

## Installation
To install the program, download the installer and execute it.

```Bash
cd ~
wget https://raw.githubusercontent.com/Angelmmiguel/pm/master/install.sh
chmod 755 ./install.sh
./install.sh
```

Type your shell when the installer ask to you:

```Bash
What is your shell? [ zsh ]: 
```

Finally, restart your terminal.

## Shells
Available shells are:
* ZSH

## Usage
Move to your awesome project and add it to `pm`:

```Bash
cd projects/awesome-project
pm add awesome-project
```

Try to add another. Next, list stored projects:

```Bash
pm list
# awesome-project
# another-project
```

To switch into a project, use `pm go`:

```Bash
pm go awesome-project
# Current project: awesome-project
```

If a project is not longer available, remove it:

```Bash
pm remove another-project
pm list
# awesome-project
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