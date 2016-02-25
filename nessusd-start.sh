#!/bin/bash
#======================================================================================================================================
#          FILE:  nessusd-start.sh
# 
#         USAGE:  chmod +x ./nessusd-start.sh && sudo ./nessusd-start.sh
# 
#   DESCRIPTION:  Start nessusd service and launch Nessus Web interface on Iceweasel web browser
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  * Have functional Nessus installation + licence key on Kali Linux
#		          * Be able to start this script as root
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Jean-Marc ALBERT
#       COMPANY:  ---
#       CREATED:  25.02.2016 20:52:37 UST
#      REVISION:  0.0.1
#======================================================================================================================================


### Variables ###
NOW=$(date +%y.%m.%d-%T)
scriptfile="$(readlink -f $0)"
CURRENT_DIR="$(dirname ${scriptfile})"


### Functions ###
	shw_info () {
    echo $(tput bold)$(tput setaf 4) $@ $(tput sgr 0)
}

### Initialisation ###

# Must be root
	if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" #1>&2
        exit 0
	fi

### Actions ###
shw_info "Starting 'nessusd' service..."
/etc/init.d/nessusd start </dev/null &>/dev/null &

shw_info "Launching Nessus web interface..."
iceweasel https://kali:8834/#/ </dev/null &>/dev/null &

exit