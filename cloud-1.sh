#!/usr/bin/env bash
set -u

# VARIABLES
INVENTORY="./inventory.ini"
PLAYBOOK="./playbook.yml"
VAULT_PASS_FILE=".vault_pass"
VAULT_FILE="./group_vars/all/vault.yml"

if [ $# -eq 0 ]; then
	echo "ERROR: Please enter server IP"
	exit 1
fi

# INSTALL: ansible
if ! command -v ansible >/dev/null 2>&1; then
    echo "Installing Ansible...."
	if ! pip install ansible-core; then
		echo "ERROR: Failed to install Ansible"
		exit 1
	fi
fi
export PATH=$PATH:~/.local/bin
echo "Ansible:	$(ansible --version | head -n 1)"

# INSTALL: dependencies
ansible-galaxy collection install community.crypto community.docker community.general

# CREATE: vault password file
if [ ! -f "$VAULT_PASS_FILE" ]; then
	echo "Creating vault password file..."
	if ! openssl rand -base64 32 > "$VAULT_PASS_FILE"; then
		echo "ERROR: Failed to create vault password file"
		exit 1
	fi
	chmod 600 "$VAULT_PASS_FILE"
	echo "Vault password file created: $VAULT_PASS_FILE"

	# Add to .gitignore if not already there
	if ! grep -q "$VAULT_PASS_FILE" .gitignore 2>/dev/null; then
		echo "$VAULT_PASS_FILE" >> .gitignore
		echo "Added $VAULT_PASS_FILE to .gitignore"
	fi
else
	echo "Vault password file already exists: $VAULT_PASS_FILE"
fi

# CREATE: vault file
if [ ! -f "$VAULT_FILE" ]; then
	echo "Creating vault file..."
	mkdir -p "$(dirname "$VAULT_FILE")"
	if ! ansible-vault create "$VAULT_FILE" --vault-password-file "$VAULT_PASS_FILE"; then
		echo "ERROR: Failed to create vault file"
		exit 1
	fi
	echo "Vault file created: $VAULT_FILE"
else
	echo "Vault file already exists: $VAULT_FILE"
fi

# CREATE: inventory
echo "[cloud1hosts]" > "$INVENTORY"
for arg in "$@"; do
	echo "$arg" >> "$INVENTORY"
done
echo "Inventory:	$INVENTORY"

# CHECK: playbook
if [ ! -f "$PLAYBOOK" ]; then
	echo "ERROR: Playbook file not found"
	exit 1
fi
echo "Playbook:	$PLAYBOOK"

# CLEANUP FUNCTION
cleanup() {
	[ -f "$INVENTORY" ] && rm "$INVENTORY"
}
trap cleanup EXIT

# RUN
echo "Running:	ansible-playbook -i $INVENTORY $PLAYBOOK"
ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --vault-password-file "$VAULT_PASS_FILE"