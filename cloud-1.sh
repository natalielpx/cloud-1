#!/usr/bin/env bash
set -e

# VARIABLES
ANSIBLE_DIR="./ansible"
INVENTORY="$ANSIBLE_DIR/inventory.ini"
PLAYBOOK="$ANSIBLE_DIR/playbook.yml"

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
echo "[cloud1hosts]"	> "$INVENTORY"
for arg in "$@"; do
	echo "$arg ansible_user=root"			>> "$INVENTORY"
done
echo "Inventory:	$INVENTORY"

# CHECK: playbook
if [ ! -f $PLAYBOOK ]; then
	echo "ERROR: Playbook file not found"
	exit 1;
fi
echo "Playbook:	$PLAYBOOK"

# RUN
echo "Running:	ansible-playbook -i $INVENTORY $PLAYBOOK"
ansible-playbook -i "$INVENTORY" "$PLAYBOOK"