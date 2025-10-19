#!/usr/bin/env bash
set -e

# VARIABLES
INVENTORY="./inventory.ini"
PLAYBOOK="./playbook.yml"
FILES_DIR="./roles/application/files"

if [ $# -eq 0 ]; then
	echo "ERROR: Please enter server IP"
	exit 1
fi

# INSTALL: ansible
if ! command -v ansible >/dev/null 2>&1; then
    echo "Installing Ansible...."
	if ! pipx install ansible-core; then
		echo "ERROR: Failed to install Ansible"
		exit 1
	fi
fi
echo "Ansible:	$(ansible --version | head -n 1)"

# INSTALL: dependencies
ansible-galaxy collection install community.crypto community.docker community.general

# CREATE: inventory
echo "[cloud1hosts]" > "$INVENTORY"
for arg in "$@"; do
	echo "$arg ansible_user=root" >> "$INVENTORY"
done
echo "Inventory:	$INVENTORY"

# CREATE: .env for each host
for arg in "$@"; do
	cp .env "$FILES_DIR/.env.$arg"
	echo "$arg" >> "$FILES_DIR/.env.$arg"
done

# CHECK: playbook
if [ ! -f $PLAYBOOK ]; then
	echo "ERROR: Playbook file not found"
	exit 1;
fi
echo "Playbook:	$PLAYBOOK"

# RUN
echo "Running:	ansible-playbook -i $INVENTORY $PLAYBOOK"
ansible-playbook -i "$INVENTORY" "$PLAYBOOK"

# REMOVE GENERATED ENV FILES
for arg in "$@"; do
    [ -f "$FILES_DIR/.env.$arg" ] && rm "$FILES_DIR/.env.$arg"
done