# Install for Ubuntu 24.04

These Instructions are based on [PimpMyLifeUp's](https://pimylifeup.com/7-days-to-die-server-linux/) fantastic instructions.

## Minimum System Specifications*

* 8 GB of RAM
* 8 GB Swap File

_*These specifications will support 2-4 players without any issues._

### This is what I am currently running from [Linode.com](https://www.linode.com/pricing/) under Shared CPU Plans.

|Plan|$/Mo|$/Hr|RAM|CPUs|Storage|Transfer|Network In/Out|
|----|----|----|---|----|-------|--------|--------------|
|Linode 8 GB|$48*|$0.072|8 GB|4|160 GB|5 TB|40/5 Gbps|

_* Only running the server when playing is a great way to save on monthly running costs._

## Preparing your Linux System

### 1. Update your instance.

```Shell
sudo apt update
sudo apt upgrade -y
```

### 2. Install package dependencies.

```Shell
sudo apt install software-properties-common
```

## Setting up SteamCMD on your Linux Machine

### 3. Install i386 architecture.

```Shell
sudo dpkg --add-architecture i386
```

### 4. Add additional repositories.

```Shell
sudo apt-add-repository multiverse
```

### 5. Update package manager for new repo.

```Shell
sudo apt update
```

### 6. Install SteamCMD.

```Shell
sudo apt install steamcmd
```

## Creating a Linux User to Run the 7 Days to Die Dedicated Server

### 7. Create 7days user.

```Shell
sudo useradd -m 7days
```

### 8. Switch to new user terminal.

```Shell
sudo -u 7days -s
```

### 9. Switch to root directory.

```Shell
cd ~
```

## Downloading the Latest Version of the 7 Days to Die Server on Linux

### 10. Install 7 Days to Die server software.

#### Stable Release

```Shell
/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "/home/7days/server" +login anonymous +app_update 294420 -validate +quit
```

#### Latest Experimental Release

```Shell
/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "/home/7days/server" +login anonymous +app_update 294420 -beta latest_experimental -validate +quit
```

## Configuring the 7 Days to Die Server

### 11. Edit/Set the server configurations.

```Shell
nano /home/7days/server/serverconfig.xml
```

### 12. Review what to set for the server configuration.

#### Short List of Important Settings

[Running a 7 Days to Die Server on Linux >> Starts at Step 12](https://pimylifeup.com/7-days-to-die-server-linux/)

#### Full Settings List

[7 Days to Die Dedicated Servers](https://developer.valvesoftware.com/wiki/7_Days_to_Die_Dedicated_Server#Windows_Requirement)

### 13. Exit 7days user.

```Shell
exit
```

### 14. Create service file to manage 7DTD start/stop.

```Shell
sudo nano /etc/systemd/system/7daystodie.service 
```

### 15. Add this to your service file based on your needs.

#### Update 7DTD Software at Service Start

Choose this option if you want the server to update 7 Days to Die software before starting the service.

Keep your serverconfig.xml in the user root to prevent overwriting by updates.

If utilizing `ExecStartPre` then make sure to call the correct branch of the software.

```Shell
[Unit]
Description=7 Days to Die Dedicated Server
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
Restart=on-failure
RestartSec=10
User=7days
Group=7days
WorkingDirectory=/home/7days/server
ExecStartPre=/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "/home/7days/server" +login anonymous +app_update 294420 -validate +quit
ExecStart=/home/7days/server/startserver.sh -configfile=/home/7days/serverconfig.xml
ExecStop=-/bin/bash -c "echo 'shutdown' | /usr/bin/telnet 127.0.0.1 8081"

[Install]
WantedBy=multi-user.target
```

#### Do Not Update 7DTD Software at Service Start

```Shell
[Unit]
Description=7 Days to Die Dedicated Server
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
Restart=on-failure
RestartSec=10
User=7days
Group=7days
WorkingDirectory=/home/7days/server
ExecStart=/home/7days/server/startserver.sh -configfile=/home/7days/serverconfig.xml
ExecStop=-/bin/bash -c "echo 'shutdown' | /usr/bin/telnet 127.0.0.1 8081"

[Install]
WantedBy=multi-user.target
```

### 16. Save the server configuration file.

```
CTRL + X > Y, and then ENTER
```

### 17. Enable your newly created service.

```Shell
sudo systemctl enable 7daystodie
```

### 18. Start the 7DTD service.

```Shell
sudo systemctl start 7daystodie
```

### 19. Check that your server is up.

You can check if your server is up and running at [Is my Game Server Online?](https://ismygameserver.online/protocol-valve/45.79.167.184:26900)

```
SERVER_IP:SERVER_PORT
```

### 20. Check out 7DTD Management Tools

[Dedicated Server Management Tools](https://community.7daystodie.com/topic/18294-dedicated-server-management-tools/)

# Resources

Go right to the source: [7DTD Foruns](https://community.7daystodie.com/)