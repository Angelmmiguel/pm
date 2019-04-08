#!/usr/bin/env zsh

# Use a function to perform a cd command
pm () {
  CURRENT_VERSION=0.4.0rc
  CURRENT_MAJOR=0
  CURRENT_MINOR=4
  CURRENT_PATCH=0rc
  # Base
  if [ -z "$PM_BASE" ]; then
    PM_BASE=$HOME/.pm
  fi

  # Projects file
  PFILE=$PM_BASE/projects
  # Config file
  CFILE=$PM_BASE/config
  # Version File
  VFILE=$PM_BASE/version
  # Available config values
  AVAILABLE_CONFIG=(after-all git-info)
  # Available config values for project
  AVAILABLE_PROJECT_CONFIG=(after git-info)

  #
  # Initialize projects files
  #
  pm_initialize () {
    # Create the folder
    if [ ! -d "$PM_BASE" ]; then
      mkdir $PM_BASE
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
  # Check last version of PM and perform update
  #
  pm_update_process () {
    # Load version
    MAJOR=0
    MINOR=0
    PATCH=0
    RC=false

    if [ ! -f $VFILE  ]; then
      # The file don't exist
      MINOR=1
    else
      version_file=$(head -n 1 $VFILE)
      version=("${(@s/./)version_file}")
      MAJOR=$version[1]
      MINOR=$version[2]
      PATCH=$version[3]
      # Check if this version is a release candidate
      if [[ "$PATCH" =~ rc ]]; then
        RC=true
      fi
    fi

    if [[ MAJOR -eq 0 && MINOR -eq 1 ]]; then
      update_0_1_to_0_2
    fi

    save_version "$CURRENT_MAJOR.$CURRENT_MINOR.$CURRENT_PATCH"
  }

  #
  # Show the help of the project
  #
  show_help () {
    echo "PM is a simple project manager. Switch to your projects faster"
    echo "and improve your productivity."
    echo ""
    echo "Usage:"
    echo "   pm <add|config|config-project|help|go|list|remove|version>"
    echo ""
    echo "Commands:"
    echo "   add \\t\\t\\t Add a new project based on current path"
    echo "   config \\t\\t Change global configuration parameters"
    echo "   config-project \\t Change the configuration of a project"
    echo "   help \\t\\t Show this help"
    echo "   go \\t\\t\\t Switch to a project"
    echo "   list \\t\\t Show a list of stored projects"
    echo "   remove \\t\\t Remove the project from PM"
    echo "   version \\t\\t Show current version"
  }

  #
  # Save the current version in Version file
  #
  # $1 : String with current version of pm
  #
  save_version () {
    # Create version file
    if [ -f $VFILE  ]; then
      rm -f $VFILE
    fi
    # Save the version
    echo "$1" > $VFILE
  }

  #
  # Update the project file from 0.1 version to 0.2
  #
  update_0_1_to_0_2 () {
    current_projects=()
    while read -r line
    do
      if [[ $line =~ ^.*:.* ]]; then
        el=("${(@s/:/)line}") # : modifier
        current_projects+=($el[1])
      fi
    done < "$PFILE"

    for i in "${current_projects[@]}"; do
      sed -i '' "/$i:.*/a\\
                 /$i\\
                " $PFILE
    done
  }

  #
  # Find a line that starts with an string. Return the index
  #
  # $1 : String that start the line
  # $2 : Path to the file
  #
  find_line_starts () {
    # Indexes
    local index=1
    local delete=0
    # Read all lines
    while read -r line
    do
      if [[ $line == "$1"* ]]; then
        delete=$index
      fi
      index=$((index + 1))
    done < "$2"

    echo "$delete"
  }

  #
  # Check if the project given exist or exit the program
  #
  # $1 : name of the project
  #
  check_project () {
    local project
    project=$(find_line_starts "$1:" $PFILE)

    # Check if project exist
    if [[ $project -eq 0  ]]; then
      echo 'no'
    else
      echo 'ok'
    fi
  }

  #
  # Delete a line of a file that start with given string
  #
  # $1 : String that start the line
  # $2 : Path to the file
  #
  delete_line_starts () {
    # Get the index to delete
    local delete
    delete=$(find_line_starts "$1" "$2")
    # Check if the line exist
    if [[ $delete -eq 0  ]]; then
      return 0
    else
      # Delete
      sed -i -e "${delete},1d" "$2"
      return 1
    fi
  }

  #
  # Add the config parameter to a project
  #
  # $1 : String with project
  # $2 : String with key of config
  # $3 : String with value config
  #
  add_config_to_project () {
    # Project
    local project=$1

    # Delete the project property if exist
    delete_project_property "$1" "$2"

    # Add the config
    sed -i "/$1:.*/a\\$2=$3\\" $PFILE
  }

  #
  # Delete a property of a project
  #
  # $1 : String with the project
  # $2 : String with the property
  #
  delete_project_property () {
    # Find the project
    local project=$1
    local index=0
    local in_project=false
    local delete=0

    # Read config paramteres
    while read -r line
    do
      if [[ $line == "$1:"* ]]; then
        in_project=true
      elif [[ $line == "/$1"* ]]; then
        in_project=false
      elif [[ (in_project) ]]; then
        config=("${(s/=/)line}")
        if [[ $config[1] == "$2" ]]; then
          delete=$((index + 1))
        fi
      fi
      index=$((index + 1))
    done < "$PFILE"

    # Check if we need to delete the config
    if [[ $delete -ne 0  ]]; then
      sed -i -e "${delete},1d" $PFILE
    fi
  }

  #
  # Read a config value of a project
  #
  # $1 : String with the name of the project
  # $2 : String with the name of value
  #
  # Return : CONFIG_VALUE
  #
  get_config_project_value () {
    # Find the project
    local project=$1
    local in_project="no"
    local value=""

    # Read config paramteres
    while read -r line
    do
      if [[ $line == "$1:"* ]]; then
        in_project="yes"
      elif [[ $line == "/$1"* ]]; then
        in_project="no"
      elif [[ "$in_project" == "yes" ]]; then
        config=("${(s/=/)line}")
        if [[ $config[1] == "$2" ]]; then
          value=$config[2]
        fi
      fi
    done < "$PFILE"

    # Return the value
    echo "$value"
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
    local config_value=""
    while read -r line
    do
      el=("${(@s/=/)line}") # @ modifier
      if [[ $el[1] == "$1" ]]; then
        # Return the value
        config_value=$el[2]
      fi
    done < "$CFILE"
    # Return the value
    echo "$config_value"
  }

  #
  # Get Git branch of current project
  #
  get_branch () {
    branch=$(git branch | grep "*")
    branch=("${(@s/ /)branch}")
    branch=$branch[2]
    echo "${branch[@]}"
  }

  # Initialize folders and file if isn't exists
  pm_initialize
  # Update process of project! :D
  pm_update_process

  # Check commands. Available commands are add|remove|go (go by default)
  if [ $# -lt 1 ]; then
    show_help
  else
    case "$1" in
      'help' )
        show_help
        ;;
      'ready' )
        echo "PM is available in your console. Enjoy ;)"
        ;;
      # Add a project
      'add' | 'a' )
        # Name of the project
        if [ -z "$2" ]; then
            NAME=$(basename "$(pwd)")
        else
            NAME="$2"
        fi
        # Check if project exist
        project=$(check_project "$NAME")
        if [[ "$project" == "no" ]]; then
          PM_PROJ_PATH=$(pwd)

          # Add it to the file
          echo "$NAME:$PM_PROJ_PATH" >> $PFILE
          echo "/$NAME" >> $PFILE
        else
          echo "The project $NAME already exists"
        fi
        ;;
      # Add a config valeu to the program
      'config' )
        if [[ $2 == "add" ]]; then
          # Add a new config parameter
          if [[ ${AVAILABLE_CONFIG[(r)$3]} == "$3" ]]; then
            # Delete the line and save new command
            delete_line_starts "$3=" $CFILE
            echo "$3=$4" >> $CFILE
            echo "The configuration has been updated"
          else
            echo "The config parameter $3 doesn't exist"
          fi
        elif [[ $2 == "remove" ]]; then
          # Remove the element
          if [[ ${AVAILABLE_CONFIG[(r)$3]} == "$3" ]]; then
            # Delete the line and save new command
            delete_line_starts "$3=" $CFILE
            echo "The configuration parameter $3 has been updated"
          else
            echo "The config parameter $3 doesn't exist"
          fi
        elif [[ $2 == "get" ]]; then
          # Show the value of element
          if [[ ${AVAILABLE_CONFIG[(r)$3]} == "$3" ]]; then
            # Delete the line and save new command
            config_value=$(get_config_value "$3")
            echo "The configuration value for $3 is: $config_value"
          else
            echo "The config parameter $3 doesn't exist"
          fi
        else
          echo "Config usage: pm config <add|get|remove> <parameter> (value)"
        fi
        ;;
      # Add a property to a project
      'config-project' )
        # Check if project exist
        project=$(check_project "$2")
        if [[ "x$project" == "xok" ]]; then
          # Continue
          if [[ $3 == "add" ]]; then
            # Add a new config parameter
            if [[ ${AVAILABLE_PROJECT_CONFIG[(r)$4]} == "$4" ]]; then
              add_config_to_project "$2" "$4" "$5"
              echo "The configuration has been updated"
            else
              echo "The config parameter $4 doesn't exist"
            fi
          elif [[ $3 == "remove" ]]; then
            # Remove the element
            if [[ ${AVAILABLE_PROJECT_CONFIG[(r)$4]} == "$4" ]]; then
              # Delete the config for the project
              delete_project_property "$2" "$4"
              echo "The configuration parameter $4 has been removed"
            else
              echo "The config parameter $4 doesn't exist"
            fi
          elif [[ $3 == "get" ]]; then
            # Show the value of element
            if [[ ${AVAILABLE_PROJECT_CONFIG[(r)$4]} == "$4" ]]; then
              # Get the config value of a project
              value=$(get_config_project_value "$2" "$4")
              if [[ "x$value" == "x" ]]; then
                echo "The project hasn't got any value for $4"
              else
                echo "The configuration value for $4 is: $value"
              fi
            else
              echo "The config parameter $4 doesn't exist"
            fi
          else
            echo "Config usage: pm config-project <project> <add|get|remove> <parameter> (value)"
          fi
        else
          echo "The project $2 doesn't exist"
        fi
        ;;
      # List projects
      'list' | 'l' )
        while read -r line
        do
          if [[ $line =~ ^.*:.* ]]; then
            el=("${(@s/:/)line}") # : modifier
            in_project=true
            last_project=$el[1]
            echo $el[1]
          fi
        done < "$PFILE"
        ;;
      # Remove a project
      'remove' | 'rm' )
        # Name of the project
        NAME=$2
        # Indexes
        PM_INDEX=1
        PM_DELETE_INITIAL=0
        PM_DELETE_FINAL=0
        # Read all lines
        while read -r line
        do
          if [[ $line == "$NAME:"* ]]; then
            PM_DELETE_INITIAL=$PM_INDEX
          elif [[ $line == "/$NAME" ]]; then
            PM_DELETE_FINAL=$PM_INDEX
          fi
          PM_INDEX=$((PM_INDEX + 1))
        done < "$PFILE"

        # Check if the repo exist
        if [[ $PM_DELETE_INITIAL -eq 0  ]]; then
          echo "The project doesn't exist"
        else
          # Delete
          sed -i -e "${PM_DELETE_INITIAL},${PM_DELETE_FINAL}d" $PFILE
          echo "The project ${NAME} was deleted!"
        fi
        ;;
      # Show version
      'version' | 'v' )
          echo "$CURRENT_MAJOR.$CURRENT_MINOR.$CURRENT_PATCH"
        ;;
      # Go to the project
      'go' | 'g' )
        # Path of the project
        NAME=$2
        PM_PROJ_PATH=""

        # Read lines
        while read -r line
        do
          el=("${(@s/:/)line}") # @ modifier
          if [[ $line == "$NAME:"* ]]; then
            PM_PROJ_PATH=$el[2]
          fi
        done < "$PFILE"

        # Check if the repo exist
        if [[ "$PM_PROJ_PATH" == "" ]]; then
          echo "The project doesn't exist"
        else
          # Change the path. Show some info
          cd "$PM_PROJ_PATH"
          echo "Current project: ${NAME}"
          # Execute after all config if it exists
          exe_after=$(get_config_value "after-all")
          exe_git_info=$(get_config_value "git-info")
          exe_after_project=$(get_config_project_value "$NAME" "after")
          exe_git_info_project=$(get_config_project_value "$NAME" "git-info")

          if [[ "$exe_git_info_project" == "yes" || "$exe_git_info" == "yes" ]]; then
            if ! type "git" > /dev/null 2>&1; then
              echo "You have active Git-info option, but you haven't got Git installed."
            elif [[ -d .git ]]; then
              branch=$(get_branch)
              echo "------------"
              echo "Branch:\\t\\t $branch"
              last_commit=$(git log -1 --format="(%h) %B")
              echo "Last commit:\\t $last_commit"
              echo "Changes:"
              git status -s
              echo "------------"
            fi
          fi

          # Exec after
          if [[ "$exe_after" != "" ]]; then
            eval "$exe_after"
          fi

          if [[ "$exe_after_project" != "" ]]; then
            eval "$exe_after_project"
          fi
        fi
        ;;
      * )
        echo "The action $1 doesn't exist"
        echo ""
        show_help
        ;;
    esac
  fi
}
