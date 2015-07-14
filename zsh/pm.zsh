#!/usr/bin/env zsh

# Use a function to perform a cd command
pm () {
  # Projects file
  PFILE=~/.pm/projects
  # Config file
  CFILE=~/.pm/config
  # Base
  PM_BASE=~/.pm
  # Config available values
  AVAILABLE_CONFIG=(after-all)

  #
  # Initialize projects files
  #
  pm_initialize () {
    # Create the folder
    if [ ! -d "$PM_BASE" ]; then
      mkdir ~/.pm
    fi
    # Create projects file
    if [ ! -f $PFILE  ]; then
      echo "# File to store your projects for PM" > $PFILE
    fi
    # Create config file
    if [ ! -f $CFILE  ]; then
      echo "# Config file for PM" > $CFILE
    fi
  }

  #
  # Delete a line of a file that start with given string
  #
  # $1 : String that start the line
  # $2 : Path to the file
  #
  delete_line_starts () {
    # Indexes
    local index=1
    local delete=0
    # Read all lines
    while read line
    do
      if [[ $line == "$1"* ]]; then
        delete=$index
      fi
      index=$(($index + 1))
    done < "$2"

    # Check if the line exist
    if [[ $delete -eq 0  ]]; then
      return 0
    else
      # Delete
      sed -i -e "${delete},1d" $2
      return 1
    fi
  }

  #
  # Read a config value
  #
  # $1 : String with the key of the config paramter
  #
  # Return : CONFIG_VALUE
  #
  get_config_value () {
    # Read all lines
    CONFIG_VALUE=""
    while read line
    do
      el=("${(@s/=/)line}") # @ modifier
      if [[ $el[1] == $1 ]]; then
        # Return the value
        CONFIG_VALUE=$el[2]
      fi
    done < "$CFILE"
  }

  # Initialize folders and file if isn't exists
  pm_initialize

  # Check commands. Available commands are add|remove|go (go by default)
  if [ $# -lt 1 ]; then
    echo "Usage: pm <add|remove|go|list|config> <name of project>"
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
      # Add a config valeu to the program
      'config' )
        if [[ $2 == "add" ]]; then
          # Add a new config parameter
          if [[ ${AVAILABLE_CONFIG[(r)$3]} == $3 ]]; then
            # Delete the line and save new command
            delete_line_starts "$3=" $CFILE
            echo "$3=$4" >> $CFILE
            echo "The configuration has been updated"
          else
            echo "The config parameter $2 doesn't exist"
          fi
        elif [[ $2 == "remove" ]]; then
          # Remove the element
          if [[ ${AVAILABLE_CONFIG[(r)$3]} == $3 ]]; then
            # Delete the line and save new command
            delete_line_starts "$3=" $CFILE
            echo "The configuration parameter $3 has been updated"
          else
            echo "The config parameter $3 doesn't exist"
          fi
        elif [[ $2 == "get" ]]; then
          # Show the value of element
          if [[ ${AVAILABLE_CONFIG[(r)$3]} == $3 ]]; then
            # Delete the line and save new command
            get_config_value "after-all"
            echo "The configuration value for $3 is: $CONFIG_VALUE"
          else
            echo "The config parameter $3 doesn't exist"
          fi
        else
          echo "Config usage: pm config <add|get|remove> <parameter> (value)"
        fi
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
          # Execute after all config if it exists
          get_config_value "after-all"
          exe_after=$CONFIG_VALUE
          if [[ "$exe_after" != "" ]]; then
            eval $exe_after
          fi
        fi
        ;;
    esac
  fi
}