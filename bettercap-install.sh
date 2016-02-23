#!/bin/bash
#======================================================================================================================================
#          FILE:  bettercap-install.sh
# 
#         USAGE:  chmod +x ./bettercap-install.sh && sudo ./bettercap-install.sh
# 
#   DESCRIPTION:  Install bettercap (modular, portable and easily extensible MITM framework) and dependencies
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  * Have Internet access on host
#				  * Be able to start this script as root
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Jean-Marc ALBERT
#       COMPANY:  ---
#       CREATED:  23.02.2016 19:13:37 UST
#      REVISION:  0.0.1
#======================================================================================================================================


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

### Initialisation ###

# Must be root
	if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" #1>&2
        exit 0
	fi

### Actions ###
shw_info "Start root instance"
su root

shw_info "Doing updates..."
sudo apt -y update

shw_info "Installing dependencies"
sudo apt -y install build-essential ruby-dev libpcap-dev gem

shw_info "Installing bettercap (stable)"
gem install bettercap

shw_info "Starting bettercap with help"
bettercap --help