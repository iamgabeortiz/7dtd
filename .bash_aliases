# shellcheck shell=bash



# 7 Days To Die

## Server Management
function update_aliases() {
    aws s3 cp s3://myawsstack-mains3bucket5c2e6ab2-1s84nhxrj9ksj/7days/.bash_aliases .bash_aliases
    source .bash_alises
}

alias start_7dtd="systemctl start 7daystodie"
alias stop_7dtd="systemctl stop 7daystodie"
alias status_7dtd="systemctl status 7daystodie"

function update_stable_7dtd() {
    /usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "/home/7days/server" +login anonymous +app_update 294420 -validate +quit
    chown -R 7days:7days /home/7days/server
}

function update_exp_7dtd() {
    /usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir "/home/7days/server" +login anonymous +app_update 294420 -beta latest_experimental -validate +quit
    chown -R 7days:7days /home/7days/server
}

function update_config_files() {
    aws s3 cp s3://myawsstack-mains3bucket5c2e6ab2-1s84nhxrj9ksj/7days/serverconfig.xml /home/7days/serverconfig.xml
    chown 7days:7days /home/7days
    aws s3 cp s3://myawsstack-mains3bucket5c2e6ab2-1s84nhxrj9ksj/7days/serveradmin.xml /home/7days/.local/share/7DaysToDie/Saves/serveradmin.xml
    chown 7days:7days /home/7days/.local/share/7DaysToDie/Saves/serveradmin.xml
}

function update_mods() {
    aws s3 cp s3://myawsstack-mains3bucket5c2e6ab2-1s84nhxrj9ksj/KhaineV1XMLModlets/KHV1-12CraftQueue /home/7days/server/Mods/KHV1-12CraftQueue
    aws s3 cp s3://myawsstack-mains3bucket5c2e6ab2-1s84nhxrj9ksj/KhaineV1XMLModlets/KHV1-3SlotForge /home/7days/server/Mods/KHV1-3SlotForge
    aws s3 cp s3://myawsstack-mains3bucket5c2e6ab2-1s84nhxrj9ksj/KhaineV1XMLModlets/KHV1-60BBM /home/7days/server/Mods/KHV1-60BBM
    chown 7days:7days /home/7days/server/Mods
}

# AWS

## aws cli
function update_awscli() {
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    rm -rf aws
    ./aws/install --update
    rm awscliv2.zip
}