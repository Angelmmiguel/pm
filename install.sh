#!/usr/bin/env sh

#
# Script to install pm in your system! Only execute and see the magic ;)
#

FROM_UPDATE="no"
VERSION="v0.4"
PRERELEASE="no"

#
# Show a message that selected shell is not currently available.
#
shell_not_available () {
  echo "Now, your console isn't available :(. Create an issue on: https://github.com/Angelmmiguel/pm/issues."
}

# Check if requested version is a prerelease
if [ "$#" -eq 1 ] && [ "$1" = "--prerelease" ]; then
  PRERELEASE="yes"
  VERSION="master"
fi

echo "Hello! I'm here to help you to install PM"

if [ -z $PM_BASE ]; then
  PM_BASE=$HOME/.pm
fi

if [ -d $PM_BASE ]; then
  # Is installed!
  printf "PM is installed. Update it? [ yes or no ]: "
  read update

  if [ "$update" = "yes" ]; then
    echo "Updating PM..."
    FROM_UPDATE="yes"
  else
    exit 0
  fi
fi

# In this case, Bash is only available in prerelease
if [ $PRERELEASE = "yes" ]; then
  SHELLS="zsh, bash"
else
  SHELLS="zsh"
fi

# Check the current console.
printf "What's your shell? [ $SHELLS ]: "
read console
echo "Installing $VERSION version..."

case "$console" in
  'zsh' )
    # Create folder and download file
    mkdir -p $ZSH_CUSTOM/plugins/pm

    if [ "$FROM_UPDATE" = "no" ]; then
      mkdir $PM_BASE
    fi

    $(wget --quiet https://raw.githubusercontent.com/Angelmmiguel/pm/${VERSION}/zsh/pm.zsh -o /tmp/pm.zsh)
    mv /tmp/pm.zsh $PM_BASE

    $(wget --quiet https://raw.githubusercontent.com/Angelmmiguel/pm/${VERSION}/zsh/_pm -o /tmp/_pm)
    mv /tmp/_pm $ZSH_CUSTOM/plugins/pm/_pm

    # Add the function to the console
    if [ "$FROM_UPDATE" = "no" ]; then
      echo "" >> .zshrc
      echo "# PM functions" >> .zshrc
      echo "source $PM_BASE/pm.zsh" >> .zshrc
      # Add some aliases
      echo "alias pma=\"pm add\"" >> .zshrc
      echo "alias pmg=\"pm go\"" >> .zshrc
      echo "alias pmrm=\"pm remove\"" >> .zshrc
      echo "alias pml=\"pm list\"" >> .zshrc
      echo "# end PM" >> .zshrc
    fi

    # Done
    if [ "$FROM_UPDATE" = "yes" ]; then
      echo "PM is updated! Please, restart your session."
    else
      echo "PM is installed! Please, restart your session."
    fi
  ;;
  'bash' )
    # In current stable version, there not bash support
    if [ "$PRERELEASE" = "no" ]; then
      shell_not_available
      exit 0
    fi
    # Create folder and download file
    if [ "$FROM_UPDATE" = "no" ]; then
      mkdir $PM_BASE
    fi
    $(wget --quiet https://raw.githubusercontent.com/Angelmmiguel/pm/${VERSION}/bash/pm.bash -o /tmp/pm.bash)
    mv /tmp/pm.bash $PM_BASE

    # Add the function to the console
    if [ "$FROM_UPDATE" = "no" ]; then
      echo "" >> .bash_profile
      echo "# PM functions" >> .bash_profile
      echo "source $PM_BASE/pm.bash" >> .bash_profile
      # Add some aliases
      echo "alias pma=\"pm add\"" >> .bash_profile
      echo "alias pmg=\"pm go\"" >> .bash_profile
      echo "alias pmrm=\"pm remove\"" >> .bash_profile
      echo "alias pml=\"pm list\"" >> .bash_profile
      echo "# end PM" >> .bash_profile
    fi

    # Done
    if [ "$FROM_UPDATE" = "yes" ]; then
      echo "PM is updated! Please, restart your session."
    else
      echo "PM is installed! Please, restart your session."
    fi
  ;;

  *)
    shell_not_available
    ;;
esac
