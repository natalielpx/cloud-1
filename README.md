

create a strong password
```sh
openssl rand -base64 32 > .vault_pass
```

chiffrer notre mot de passe et le mettre dans group_vars/all/vault.yml
```sh
ansible-vault create group_vars/all/vault.yml --vault-password-file .vault_pass
```
