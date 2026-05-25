#!/bin/bash

USER="admin"
PASS="admin"

GREEN=$(printf '\033[32m')
BLUE=$(printf '\033[34m')
YELLOW=$(printf '\033[33m')
RESET=$(printf '\033[0m')
BOLD=$(printf '\033[1m')

print_banner() {
    clear
    printf "\n"
    printf "${BLUE}╔══════════════════════════════════════════════╗${RESET}\n"
    printf "${BLUE}║${RESET} ${BOLD}SONiC Fabric Configuration Utility${RESET}      ${BLUE}║${RESET}\n"
    printf "${BLUE}╚══════════════════════════════════════════════╝${RESET}\n"
    printf "\n"
}

apply_config() {

    NODE="$1"
    CFG="$2"

    printf "${YELLOW}[%s]${RESET} 📤 Copying config...\n" "$NODE"

    sshpass -p "$PASS" scp \
        -q \
        -o StrictHostKeyChecking=no \
        "$CFG" \
        "$USER@$NODE:/tmp/config_db.json"

    printf "${YELLOW}[%s]${RESET} 🔄 Reloading SONiC config...\n" "$NODE"

    sshpass -p "$PASS" ssh \
        -o StrictHostKeyChecking=no \
        "$USER@$NODE" "
            echo $PASS | sudo -S mv /tmp/config_db.json /etc/sonic/config_db.json &&
            sudo config reload -y
        " >/tmp/${NODE}-reload.log 2>&1

    printf "${GREEN}[%s]${RESET} ✅ Completed\n" "$NODE"
}

print_banner

apply_config leaf1 configs/fabric-config/leaf1/config_db.json &
apply_config leaf2 configs/fabric-config/leaf2/config_db.json &
apply_config spine configs/fabric-config/spine/config_db.json &

wait

printf "\n"
printf "${GREEN}${BOLD}🚀 SONiC fabric deployment completed successfully${RESET}\n"
printf "\n"

printf "${BLUE}Logs:${RESET}\n"
printf "  /tmp/leaf1-reload.log\n"
printf "  /tmp/leaf2-reload.log\n"
printf "  /tmp/spine-reload.log\n\n"
