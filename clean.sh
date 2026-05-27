
# VARIABLES
INVENTORY="./inventory.ini"
PLAYBOOK="./playbook.yml"

echo "[cloud1hosts]" > "$INVENTORY"
for arg in "$@"; do
	echo "$arg" >> "$INVENTORY"
done
echo "Inventory:	$INVENTORY"

ansible-playbook clean.yml -i inventory.ini --vault-password-file .vault_pass

[ -f "$INVENTORY" ] && rm "$INVENTORY"
