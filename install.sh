#!/usr/bin/env sh

#
# Script to install pm in your system! Only execute and see the magic ;)
#

FROM_UPDATE="no"

echo "Hello! I'm here to help you to install PM"

if [ -d ~/.pm ]; then
  # Is installed!
  printf "PM is installed. Update it? [ yes or no ]: "
  read update

  if [ "$update" == "yes" ]; then
    echo "Updating PM..."
    FROM_UPDATE="yes"
  else
    exit 0
  fi
fi
# Check the current console.
printf "What's your shell? [ zsh, bash ]: "
read console

case "$console" in
  'zsh' )
    # Create folder and download file
    cd ~
    if [[ "$FROM_UPDATE" == "no" ]]; then
      mkdir .pm
    fi
    wget --quiet https://raw.githubusercontent.com/Angelmmiguel/pm/master/zsh/pm.zsh
    mv pm.zsh .pm

    # Add the function to the console
    if [[ "$FROM_UPDATE" == "no" ]]; then
      echo "" >> .zshrc
      echo "# PM functions" >> .zshrc
      echo "source ~/.pm/pm.zsh" >> .zshrc
      # Add some aliases
      echo "alias pma=\"pm add\"" >> .zshrc
      echo "alias pmg=\"pm go\"" >> .zshrc
      echo "alias pmrm=\"pm remove\"" >> .zshrc
      echo "alias pml=\"pm list\"" >> .zshrc
      echo "# end PM" >> .zshrc
    fi

    # Done
    if [[ "$FROM_UPDATE" == "yes" ]]; then
      echo "PM is updated! Please, restart your session."
    else
      echo "PM is installed! Please, restart your session."
    fi
  ;;
  'bash' )
    # Create folder and download file
    cd ~
    if [[ "$FROM_UPDATE" == "no" ]]; then
      mkdir .pm
    fi
    wget --quiet https://raw.githubusercontent.com/Angelmmiguel/pm/master/bash/pm.bash
    mv pm.bash .pm

    # Add the function to the console
    if [[ "$FROM_UPDATE" == "no" ]]; then
      echo "" >> .bash_profile
      echo "# PM functions" >> .bash_profile
      echo "source ~/.pm/pm.zsh" >> .bash_profile
      # Add some aliases
      echo "alias pma=\"pm add\"" >> .bash_profile
      echo "alias pmg=\"pm go\"" >> .bash_profile
      echo "alias pmrm=\"pm remove\"" >> .bash_profile
      echo "alias pml=\"pm list\"" >> .bash_profile
      echo "# end PM" >> .bash_profile
    fi

    # Done
    if [[ "$FROM_UPDATE" == "yes" ]]; then
      echo "PM is updated! Please, restart your session."
    else
      echo "PM is installed! Please, restart your session."
    fi
  ;;

  *)
    echo "Now, your console isn't available :(. Create an issue on: https://github.com/Angelmmiguel/pm/issues."
    ;;
esac