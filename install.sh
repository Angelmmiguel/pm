#!/usr/bin/env sh

#
# Script to install pm in your system! Only execute and see the magic ;)
#

if [ -d ~/.pm ]; then
  # Is installed!
  printf "PM is installed. Reinstall? [ yes or no ]: "
  read reinstall

  if [ "$reinstall" == "yes" ]; then
    echo "Deleting old files..."
    rm -fr ~/.pm
  else
    exit 0
  fi
fi
# Check the current console.
printf "What's your shell? [ zsh ]: "
read console

case "$console" in
  'zsh' )
    # Create folder and download file
    cd ~
    mkdir .pm
    wget https://raw.githubusercontent.com/Angelmmiguel/pm/master/zsh/pm.zsh
    mv pm.zsh .pm

    # Add the function to the console
    echo "" >> .zshrc
    echo "# PM functions" >> .zshrc
    echo "source ~/.pm/pm.zsh" >> .zshrc
    # Add some aliases
    echo "alias pma=\"pm add\"" >> .zshrc
    echo "alias pmg=\"pm go\"" >> .zshrc
    echo "alias pmrm=\"pm remove\"" >> .zshrc
    echo "alias pml=\"pm list\"" >> .zshrc
    echo "# end PM" >> .zshrc

    # Reload the source
    source ~/.pm/pm.zsh

    # Ok!
    echo "PM is available in your console. Enjoy ;)"
  ;;

  *)
    echo "Now, your console isn't available :(. Create an issue on: https://github.com/Angelmmiguel/pm/issues."
    ;;
esac