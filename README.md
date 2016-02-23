# Linux

Collection of scripts for Linux hosts.

Use "menu.sh" script to automatize these actions:
  * Select script to execute
  * Download selected script
  * Execute selected script
  * Erase selected script after execution


For now, you are able to:
  * Add Kali Linux sources (Add a .sourcelist file who contains kali tool forensics packages without installing the full Kali-linux distribution)
  * Securize SSH (Modify sshd_configuration parameters and install "denyhosts" package)
  * Install bettercap (modular, portable and easily extensible MITM framework) and dependencies


From your home directory, execute:
    wget https://raw.githubusercontent.com/wikijm/Linux-Scripts/master/menu.sh
    chmod +x menu.sh
    ./menu.sh
    rm ./menu.sh
