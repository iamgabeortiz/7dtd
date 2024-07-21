#!/bin/bash
# shellcheck shell=bash

echo "Install for Ubuntu 24.04"
echo

#-----------------------------------------------------------------------#
# These Instructions are based on PimpMyLifeUp's fantastic instructions.
# https://pimylifeup.com/7-days-to-die-server-linux/
#-----------------------------------------------------------------------#

echo "Preparing your Linux System"
echo

echo "1. Update your instance."
apt update
apt upgrade -y
echo

echo "2. Install package dependencies."
apt install software-properties-common
echo

echo "2.a Needed to install the AWS CLI later."
apt install unzip
echo

echo "Setting up SteamCMD on your Linux Machine"
echo

echo "3. Install i386 architecture."
dpkg --add-architecture i386
echo

echo "4. Add additional repositories."
apt-add-repository multiverse
echo

echo "5. Update package manager for new repo."
apt update
echo

echo "6. Install SteamCMD."
apt install steamcmd
echo

echo "Creating a Linux User to Run the 7 Days to Die Dedicated Server"
echo

echo "7. Create 7days user."
useradd -m 7days
echo

echo "8. Switch to new user terminal."
#sudo -u 7days -s
#-----------------------------------------------------------------------#
# This section is augmentated for running as a single shell script.
#-----------------------------------------------------------------------#
sudo -i -u 7days bash << EOF
echo "9. Switch to root directory."
cd ~
echo

echo "Downloading the Latest Version of the 7 Days to Die Server on Linux"
echo

echo "10. Install 7 Days to Die server software."
echo

# echo "Stable Release"
#/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "/home/7days/server" +login anonymous +app_update 294420 -validate +quit
#echo

echo "Latest Experimental Release"
/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "/home/7days/server" +login anonymous +app_update 294420 -beta latest_experimental -validate +quit
echo

echo "Configuring the 7 Days to Die Server"
echo

echo "11. Edit/Set the server configurations."
nano /home/7days/server/serverconfig.xml
echo

echo "12. Review what to set for the server configuration."
echo

#-----------------------------------------------------------------------#
# Short List of Important Settings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Running a 7 Days to Die Server on Linux >> Starts at Step 12
# https://pimylifeup.com/7-days-to-die-server-linux/
#-----------------------------------------------------------------------#

#-----------------------------------------------------------------------#
# Full Settings List
# ~~~~~~~~~~~~~~~~~~
# 7 Days to Die Dedicated Servers
# https://developer.valvesoftware.com/wiki/7_Days_to_Die_Dedicated_Server#Windows_Requirement
#-----------------------------------------------------------------------#

echo "13. Exit 7days user."
#exit
EOF
echo

echo "14. Create service file to manage 7DTD start/stop."
touch /etc/systemd/system/7daystodie.service 
echo

echo "15. Add this to your service file based on your needs."
echo

#echo "Update 7DTD Software at Service Start"
#-----------------------------------------------------------------------#
# Choose this option if you want the server to update 7 Days to Die
# software before starting the service.  Keep your serverconfig.xml in
# the user root to prevent overwriting by updates.  If utilizing
# `ExecStartPre` then make sure to call the correct branch of the software.
#-----------------------------------------------------------------------#

#{
#    echo "[Unit]"
#    echo "Description=7 Days to Die Dedicated Server"
#    echo "Wants=network-online.target"
#    echo "After=network-online.target"
#    echo
#    echo "[Service]"
#    echo "Type=simple"
#    echo "Restart=on-failure"
#    echo "RestartSec=10"
#    echo "User=7days"
#    echo "Group=7days"
#    echo "WorkingDirectory=/home/7days/server"
#    echo "ExecStartPre=/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "/home/7days/server" +login anonymous +app_update 294420 -validate +quit"
#    echo "ExecStart=/home/7days/server/startserver.sh -configfile=/home/7days/serverconfig.xml"
#    echo "ExecStop=-/bin/bash -c \"echo 'shutdown' | /usr/bin/telnet 127.0.0.1 8081\""
#    echo
#    echo "[Install]"
#    echo "WantedBy=multi-user.target"
#} > /etc/contab
#echo

echo "Do Not Update 7DTD Software at Service Start"

{
    echo "[Unit]"
    echo "Description=7 Days to Die Dedicated Server"
    echo "Wants=network-online.target"
    echo "After=network-online.target"
    echo
    echo "[Service]"
    echo "Type=simple"
    echo "Restart=on-failure"
    echo "RestartSec=10"
    echo "User=7days"
    echo "Group=7days"
    echo "WorkingDirectory=/home/7days/server"
    echo "ExecStart=/home/7days/server/startserver.sh -configfile=/home/7days/serverconfig.xml"
    echo "ExecStop=-/bin/bash -c \"echo 'shutdown' | /usr/bin/telnet 127.0.0.1 8081\""
    echo
    echo "[Install]"
    echo "WantedBy=multi-user.target"
} > /etc/contab
echo

echo "16. Check that the config file saved correctly"
cat /etc/systemd/system/7daystodie.service
echo

echo "17. Enable your newly created service."
systemctl enable 7daystodie
echo

echo "18. Start the 7DTD service."
systemctl start 7daystodie
echo

echo "19. Check that your server is up."
echo
echo "You can check if your server is up and running at Is my Game Server Online? == https://ismygameserver.online/protocol-valve/45.79.167.184:26900"
echo
echo "Enter your SERVER_IP:SERVER_PORT"
echo

echo "20. Check out 7DTD Management Tools"
echo
echo "Dedicated Server Management Tools == https://community.7daystodie.com/topic/18294-dedicated-server-management-tools/"
echo
echo "Resources"
echo "Go right to the source: 7DTD Foruns == https://community.7daystodie.com/"
echo

echo "21. Configure Log File Cleanup"
echo
echo "We're using a cron job for this."
set -o noclobber
{
    echo
    echo -n "# 7 Days To Die Log File Cleanup"
    echo "@weekly 7days find /home/7days/server/7DaysToDieServer_Data -name "output_log__*.txt" -mtime +7 -exec rm -f {} +"
} >> /etc/contab
echo

echo "All done.  Enjoy the game."