#!/bin/zsh

# Use a function to perform a cd command
pm () {
  # Projects file
  PFILE=~/.pm/projects

  # Initialize projects file
  pm_initialize () {
    mkdir ~/.pm
    echo "# File to store your projects for PM" > $PFILE
  }

  # Check initialization
  if [ ! -f $PFILE ]; then
    pm_initialize
  fi

  # Check commands. Available commands are add|remove|go (go by default)
  if [ $# -lt 1 ]; then
    echo "Usage: pm <add|remove|go|list> <name of project>"
  else
    case "$1" in
      # Add a project
      'add' | 'a' )
        # Name of the project
        NAME="$2"
        PM_PROJ_PATH=$(pwd)

        # Add it to the file
        echo "$NAME:$PM_PROJ_PATH" >> $PFILE
        ;;
      # List projects
      'list' | 'l' ) 
        # Read all lines
        while read line
        do
          el=("${(@s/:/)line}") # @ modifier
          if [[ "${line}" == "#"* ]]; then
            continue
          fi
          # Show project
          echo $el[1]
        done < "$PFILE"
        ;;
      # Remove a project
      'remove' | 'rm' )
        # Name of the project
        NAME=$2
        # Indexes
        PM_INDEX=1
        PM_DELETE=0
        # Read all lines
        while read line
        do
          el=("${(@s/:/)line}") # @ modifier
          if [[ $el[1] == $NAME ]]; then
            PM_DELETE=$PM_INDEX
          fi
          PM_INDEX=$(($PM_INDEX + 1))
        done < "$PFILE"

        # Check if the repo exist
        if [[ $PM_DELETE -eq 0  ]]; then
          echo "The project doesn't exist"
        else
          # Delete
          sed -i -e "${PM_DELETE},1d" $PFILE
        fi
        ;;
      # Go to the project
      'go' | 'g' )
        # Path of the project
        NAME=$2
        PM_PROJ_PATH=""

        # Read lines
        while read line
        do
          el=("${(@s/:/)line}") # @ modifier
          if [[ $el[1] == $NAME ]]; then
            PM_PROJ_PATH=$el[2]
          fi
        done < "$PFILE"

        # Check if the repo exist
        if [[ "$PM_PROJ_PATH" == "" ]]; then
          echo "The project doesn't exist"
        else
          # Change the path. Show some info
          cd $PM_PROJ_PATH
          echo "Current project: ${NAME}"
        fi
        ;;
    esac
  fi
}