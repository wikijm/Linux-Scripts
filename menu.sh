#!/bin/bash
#=========================================================================================================================
#          FILE:  menu.sh
#
#         USAGE:  chmod +x ./menu.sh && sudo ./menu.sh
#
#   DESCRIPTION:  Menu with multiple choices, to start various scripts generally coming from WikiJM's Github repository
#
#       OPTIONS:  ---
#  REQUIREMENTS:  * Have Internet access on host
#                 * Be able to start this script as root
#          BUGS:  ---
#         NOTES:  Args: $1    =  Title of menu
#                       $2n   =  Associated function 'n' to choice
#                       $2n+1 =  Phrasing choice 'n' of menu
#        AUTHOR:  Jean-Marc ALBERT
#       COMPANY:  ---
#       CREATED:  23.02.2016 21:01:37 UST
#      REVISION:  0.0.1
#=========================================================================================================================

### Variables ###
NOW=$(date +%y.%m.%d-%T)
scriptfile="$(readlink -f $0)"
CURRENT_DIR="$(dirname ${scriptfile})"


### Functions ###
shw_grey () {
    echo $(tput bold)$(tput setaf 0) $@ $(tput sgr 0)
}
shw_norm () {
    echo $(tput bold)$(tput setaf 9) $@ $(tput sgr 0)
}
shw_info () {
    echo $(tput bold)$(tput setaf 4) $@ $(tput sgr 0)
}
shw_warn () {
    echo $(tput bold)$(tput setaf 2) $@ $(tput sgr 0)
}
shw_err ()  {
    echo $(tput bold)$(tput setaf 1) $@ $(tput sgr 0)
}

play_with_GitHub_script ()	{
	wget $SCRIPTURL
	chmod +x $SCRIPTFILENAME
	./$SCRIPTFILENAME
	rm ./$SCRIPTFILENAME
}

### Initialisation ###
# Must be root
	if [[ $EUID -ne 0 ]]; then
        shw_warn "This script must be run as root" #1>&2
        exit 0
	fi

### Actions ###
	Menu()
    {
      local -a menu fonc
      local title nbchoice
      # Constitution of menu
      if [[ $(( $# % 1 )) -ne 0 ]] ; then
         shw_err "$0 - Invalid menu" >&2
         return 1
      fi
      title="$1"
      shift 1
      set "$@" "return 0" "Exit"
      while [[ $# -gt 0 ]]
      do
         (( nbchoice += 1 ))
         fonc[$nbchoice]="$1"
         menu[$nbchoice]="$2"
         shift 2
      done
      # Displaying menu
      PS3="Your choice? "
      while :
      do
         echo
         [[ -n "$title" ]] && shw_norm "$title"
         select choice in "${menu[@]}"
         do
            if [[ -z "$choice" ]]
               then shw_err "Invalid title"
               else eval ${fonc[$REPLY]}
            fi
            break
         done || break
      done
    }
    #------------------------------------------------
    # Securize SSH
    #------------------------------------------------
    SecurizeSSH()
    {
		SCRIPTURL="https://raw.githubusercontent.com/wikijm/Linux-Scripts/master/AddKaliSources.sh"
		SCRIPTFILENAME="AddKaliSources.sh"
		play_with_GitHub_script
    }
    #------------------------------------------------
    # Securize SSH
    #------------------------------------------------
    SecurizeSSH()
    {
		SCRIPTURL="https://raw.githubusercontent.com/wikijm/Linux-Scripts/master/SecurizeSSH.sh"
		SCRIPTFILENAME="SecurizeSSH.sh"
		play_with_GitHub_script
    }
    #------------------------------------------------
    # Bettercap - Install
    #------------------------------------------------
    Bettercap-Install()
    {
		SCRIPTURL="https://raw.githubusercontent.com/wikijm/Linux-Scripts/master/bettercap-install.sh"
		SCRIPTFILENAME="bettercap-install.sh"
		play_with_GitHub_script
    }
    #------------------------------------------------
    # Raspberry - Bootstrap-install
    #------------------------------------------------
    Raspbbery_Bootstrap-install()
    {
		SCRIPTURL="https://raw.githubusercontent.com/wikijm/Raspberry-Scripts/master/Bootstrap-install.sh"
		SCRIPTFILENAME="Bootstrap-install.sh"
		play_with_GitHub_script
    }
    #------------------------------------------------
    # Main
    #================================================
    Menu \
      "+++ Menu +++"	\
      SecurizeSSH "Securize SSH"	\
      Bettercap-Install "Bettercap - Installation"	\
      Raspbbery_Bootstrap-install "Raspberry - Bootstrap-install"
