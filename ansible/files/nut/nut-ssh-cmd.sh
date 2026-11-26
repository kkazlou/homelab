#!/bin/sh
# Forced SSH command for NUT on UniFi devices (UNAS Pro, UDM-Pro), installed by
# hand as /root/nut-ssh-cmd.sh. pihole02 runs `check` from the playbook and
# `poweroff` during a power outage. See ansible/README.md (UPS shutdown).
case "$SSH_ORIGINAL_COMMAND" in
    check)    echo ok ;;
    poweroff) /sbin/poweroff ;;
    *)        echo "not allowed" >&2; exit 1 ;;
esac
